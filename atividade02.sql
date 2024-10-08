create database fazenda_palmitos_giovana;
use fazenda_palmitos_giovana;

create table palmitos(
id_palmito int auto_increment primary key,
tipo_palmito varchar(200),
preco_venda decimal(10,2),
estoque_atual int,
data_plantio date,
data_colheita date
);

create table fornecedores(
id_fornecedor int auto_increment primary key,
nome_fornecedor varchar(255),
contato varchar(15),
cidade varchar(255)
);

create table compras(
id_compra int auto_increment primary key,
id_palmito int, 
quantidade_comprada int,
data_compra date, 
preco_total decimal(10,2),
constraint fk_id_palmito_compra foreign key(id_palmito) references palmitos(id_palmito)
);

create table vendas(
id_venda int auto_increment primary key,
id_palmito int, 
quantidade_vendida int, 
data_venda date,
preco_total decimal(10,2),
constraint fk_id_palmito_venda foreign key(id_palmito) references palmitos(id_palmito)
);

insert into palmitos(tipo_palmito, preco_venda, estoque_atual, data_plantio, data_colheita) values
('Pupunha', 15.50, 200, '2023-02-15', '2024-02-15'),
('Açaí', 10.00, 150, '2023-01-10', '2024-01-10'),
('Jussara', 18.75, 80, '2023-03-05', '2024-03-05'),
('Real', 20.00, 60, '2023-04-20', '2024-04-20'),
('Pupunha Premium', 25.00, 40, '2023-05-15', '2024-05-15'),
('Açaí Orgânico', 12.50, 100, '2023-06-10', '2024-06-10'),
('Jussara Orgânico', 19.00, 70, '2023-07-22', '2024-07-22'),
('Real Orgânico', 22.50, 50, '2023-08-01', '2024-08-01'),
('Pupunha Orgânico', 16.50, 50, '2023-09-05', '2024-09-05'),
('Açaí Premium', 13.50, 120, '2023-10-12', '2024-10-12');

insert into fornecedores(nome_fornecedor, contato, cidade) values
('Fazenda Verde', '(11) 98765-4321', 'São Paulo'),
('AgroPalm', '(21) 91234-5678', 'Rio de Janeiro'),
('Orgânicos S.A.', '(47) 99876-5432', 'Florianópolis'),
('EcoPlanta', '(31) 92345-6789', 'Belo Horizonte'),
('Sustenta Verde', '(61) 99999-9999', 'Brasília'),
('HortiVida', '(81) 97654-3210', 'Recife'),
('AgroPalmito', '(19) 93210-5678', 'Campinas'),
('VerdeOrg', '(41) 94321-7654', 'Curitiba'),
('PlantarBem', '(62) 95432-1098', 'Goiânia'),
('BioPalm', '(85) 98765-1234', 'Fortaleza');

insert into compras(id_palmito, quantidade_comprada, data_compra, preco_total) values
(1, 100, '2024-01-05', 1550.00),
(2, 50, '2024-01-12', 500.00),
(3, 40, '2024-01-18', 750.00),
(4, 20, '2024-02-01', 400.00),
(5, 10, '2024-02-15', 250.00),
(6, 80, '2024-02-20', 1000.00),
(7, 50, '2024-02-25', 950.00),
(8, 30, '2024-03-02', 675.00),
(9, 40, '2024-03-10', 660.00),
(10, 70, '2024-03-18', 945.00);

INSERT INTO vendas(id_palmito, quantidade_vendida, data_venda, preco_total) VALUES
(1, 50, '2024-03-10', 775.00),
(2, 30, '2024-03-15', 300.00),
(3, 20, '2024-03-20', 375.00),
(4, 10, '2024-03-25', 200.00),
(5, 5, '2024-04-05', 125.00),
(6, 40, '2024-04-10', 500.00),
(7, 35, '2024-04-12', 665.00),
(8, 20, '2024-04-18', 450.00),
(9, 25, '2024-04-20', 412.50),
(10, 60, '2024-04-22', 810.00);

select * from palmitos;
select * from fornecedores;
select * from compras;
select * from vendas;

/*1. Consultas SQL Utilizando Where, Order By, Group By, Having:
a. Consulta 1: Listar todas as vendas de um tipo de palmito específico.*/
select p.tipo_palmito as "Tipo palmito" , v.quantidade_vendida as "Total de vendas" from vendas v
join palmitos p using(id_palmito)
where tipo_palmito = 'Açaí Orgânico'
group by p.tipo_palmito;

#b. Consulta 2: Ordenar as vendas por data, da mais recente para a mais antiga.
select v.id_venda as "ID venda", v.data_venda as "Data da venda" from vendas v
group by v.data_venda desc;

#c. Consulta 3: Exibir o total de vendas por tipo de palmito, agrupando pelo id_palmito.
select p.id_palmito as "ID palmito", p.tipo_palmito as "Tipo do palmito", v.quantidade_vendida as "Quantidade vendida" from vendas v
join palmitos p using(id_palmito)
group by p.id_palmito;

#d. Consulta 4: Listar os tipos de palmito cuja venda total excedeu 500 unidades, utilizando HAVING.
select p.tipo_palmito as "Tipo palmito", v.quantidade_vendida as "Quantidade vendida" from vendas v
join palmitos p on v.id_palmito = p.tipo_palmito
group by tipo_palmito
having quantidade_vendida > 500;

/*2. Criação de Funções, Procedures e Triggers:
a. Calcular o total de vendas de um palmito*/

delimiter //
create function totalVendas(id int) returns int
begin
declare qtd int;
select sum(quantidade_vendida) into qtd from vendas where id_palmito = id;
return ifnull(qtd, 0);
end//
delimiter ;

select totalVendas(1) as "Total vendas";


#b. Inserir uma nova venda e atualizar o estoque.
delimiter //
create function valorTotalVenda(id int, qtd int) returns decimal(10,2)
begin
declare valorTotal decimal(10,2);
declare precoUni decimal(10,2);
select preco_venda into precoUni from palmitos where palmitos.id_palmito = id_palmito limit 1;
if precoUni is null then return 0;
end if;
set valorTotal = precoUni * qtd;
return valorTotal;
end//
delimiter ;

delimiter //
create procedure novaVenda(in id_palmito int, in qtd int)
begin
declare valorTotal int;
set valorTotal = valorTotalVenda(id_palmito, qtd);
insert into vendas(id_palmito, quantidade_vendida, data_venda, preco_total) values
(id_palmito, qtd, curdate(), valorTotal);
end//
delimiter ;
call novaVenda(1, 20);
select * from vendas where id_palmito = 1;

delimiter //
create function atualizaEstoque(id int, qtd int) returns int
begin
declare estoqueAtual int;
declare estoqueAtualizado int;
select estoque_atual into estoqueAtual from palmitos where palmitos.id_palmito = id;
set estoqueAtualizado = estoqueAtual - qtd;
return estoqueAtualizado;
end//
delimiter ;

delimiter //
create procedure baixarEstoque(in id int, in qtd int)
begin
declare estoqueAtualizado int;
set estoqueAtualizado = atualizaEstoque(id, qtd);
update palmitos set estoque_atual = estoqueAtualizado where id_palmito = id; 
end//
delimiter ;
call baixarEstoque(1, 20);
select * from palmitos where id_palmito = 1;


#c. Atualizar o estoque automaticamente ao inserir uma nova compra
delimiter //
create function valorTotalCompra(id int, qtd int) returns decimal(10,2)
begin
declare valorTotal decimal(10,2);
declare precoUni decimal(10,2);
select preco_venda into precoUni from palmitos where palmitos.id_palmito = id_palmito limit 1;
if precoUni is null then return 0;
end if;
set valorTotal = precoUni * qtd;
return valorTotal;
end//
delimiter ;

delimiter //
create procedure novaCompra(in id_palmito int, in qtd int)
begin
declare valorTotalCompra int;
set valorTotalCompra = valorTotalCompra(id_palmito, qtd);
insert into compras(id_palmito, quantidade_comprada, data_compra, preco_total) values
(id_palmito, qtd, curdate(), valorTotalCompra);
end//
delimiter ;

call novaCompra(1, 20);
select * from compras where id_palmito = 1;
select * from compras;
select * from palmitos;

delimiter //
create function atualizaEstoqueCompras(id int, qtd int) returns int
begin
declare estoqueAtual int;
declare estoqueAtualizado int;
select estoque_atual into estoqueAtual from palmitos where palmitos.id_palmito = id;
set estoqueAtualizado = estoqueAtual - qtd;
return estoqueAtualizado;
end//
delimiter ;

delimiter //
create procedure baixarEstoqueCompras(in id int, in qtd int)
begin
declare estoqueAtualizado int;
set estoqueAtualizado = atualizaEstoque(id, qtd);
update palmitos set estoque_atual = estoqueAtualizado where id_palmito = id; 
end//
delimiter ;
call baixarEstoqueCompras(1, 20);
select * from palmitos where id_palmito = 1;
select * from compras;
select * from palmitos;

delimiter //
create trigger comprar after insert on compras for each row
begin
	call baixarEstoqueCompras(new.id_palmito, new.quantidade_comprada);
end //
delimiter ;

select * from palmitos;
select * from compras;
call novaCompra(6, 30);