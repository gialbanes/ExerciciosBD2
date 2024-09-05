create database sistemaVendasLivros;
use sistemaVendasLivros;

create table autores(
autorId int auto_increment primary key,
nome varchar(255),
pais varchar(50)
);

create table livros(
livroId int auto_increment primary key,
titulo varchar(255),
autorId int,
preco decimal(10,2),
estoque int default 0,
constraint fk_autorIdLivros foreign key (autorId) references autores(autorId)
);

create table vendas(
vendaId int auto_increment primary key,
livroId int,
dtVenda date,
qtd int,
valorTotal decimal(10,2),
constraint fk_livroIdVendas foreign key (livroId) references livros(livroId)
);

insert into autores(nome,pais) values
('Machado de Assis', 'Brasil'),
('Clarice Linspector', 'Brasil'),
('Jorge Amado', 'Brasil');

insert into livros(titulo, autorId, preco, estoque) values
('Dom Casmurro', 1, 34.90, 12),
('A hora da estrela ', 2, 29.90, 7),
('Capitães de Areia', 3, 39.90, 9);

insert into vendas(livroId, dtVenda, qtd, valorTotal) values 
(1, '2024-09-01', 3, 104.78),
(2, '2024-09-02', 2, 59.80),
(3, '2024-09-03', 1, 39.90);

select * from autores;
select * from livros;
select * from vendas;

#Criar funções
# 1° passo: mudar o delimitador das consultas para não causar conflitos
# deve declarar a variável de fato e qual o tipo de dado que ela recebe

#a função é escrita aqui dentro
#função calcula total de vendas
Delimiter //
create function TotalVendas() returns decimal(10,2) #criando a função
begin #abrir chaves
declare total decimal(10,2); #declaração de variáveis
select sum(valorTotal) into total from vendas; #selecionando a soma do valorTotal da tabela vendas e inserindo na variável total 
return ifnull(total, 0);
end // #fechar chave
Delimiter ;

select totalVendas() as 'Valor total das vendas';

#função calcula venda
delimiter //
create function calcularVenda(id int, qtd int) returns decimal(10,2)
begin
#declarar variáveis
declare valorTotal decimal(10,2);
declare precoUni decimal(10,2);

#buscar o preço unitário do livro na tabela livros
select preco into precoUni from livros where livros.livroId = id limit 1;

#verificar se o retorno é nulo
if precoUni is null then return 0;
end if;

#calcular o valor total do produto
set valorTotal = precoUni * qtd;
return valorTotal;
end//
delimiter ;

select * from livros;
select calcularVenda(3,3);

# função calcula estoque
delimiter //
create function calculaEstoque(id int, qtd int) returns int
begin
	declare estoqueAtual int;
    declare estoqueAtualizado int;
    
    select estoque into estoqueAtual from livros where livroId = id limit 1;
    set estoqueAtualizado = estoqueAtual - qtd;
    return estoqueAtualizado;
end//
delimiter ;

select * from livros;
select calculaEstoque(1,2);

#Procedure registrar venda
delimiter //
create procedure RegistrarVenda(in id int, in qtd int) 
begin
	declare valorTotal decimal(10,2);
    
    set valorTotal = calcularVenda(id, qtd); #não faço o calculo diretamente, já tenho uma função que faz isso
    insert into vendas(livroId, dtVenda, qtd, valorTotal) values
    (id, curdate(), qtd, valorTotal);
end//
delimiter ;

select * from vendas;

#executar procedure
call RegistrarVenda(3,2); #invocando a função

delimiter //
create procedure baixarEstoque(in id int, in qtd int)
begin
	declare estoqueAtualizado int;
    
    set estoqueAtualizado = calculaEstoque(id, qtd);
    
    update livros set estoque=estoqueAtualizado where livroId=id;
end//
delimiter ;

select * from livros;
call baixarEstoque(2,5);

#criar trigger
delimiter //
create trigger vender after insert on vendas for each row
begin
	call baixarEstoque(new.livroId, new.qtd);
end//
delimiter ;

select * from livros;
select * from vendas;
call RegistrarVenda(1,8);