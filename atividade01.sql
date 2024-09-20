create database if not exists emptech_giovana;
 
use emptech_giovana;

create table if not exists funcionarios(
codFunc int auto_increment primary key,
nomeFunc varchar(255) not null,
codAtuacao int
);

create table if not exists veiculos(
codVeic int auto_increment primary key,
modelo varchar(255) not null,
placas varchar(20) not null,
codFunc int
);

insert into funcionarios(nomeFunc, codAtuacao) values
('João Silva', 9),
('Maria Oliveira', 3),
('Pedro Santos', 2),
('Ana Costa', 1),
('Lucas Almeida', 5),
('Fernanda Lima', 4),
('Giovana Albanês', 8),
('Arthur Fudali', 6),
('Amanda Costa', 10);

select * from funcionarios;


insert into veiculos(modelo, placas, codFunc) values
('Fiat Uno', 'ABC1D23', 1),
('Honda Civic', 'XYZ2E34', 1),
('Toyota Corolla', 'LMN3F45', 2),
('Chevrolet Onix', 'OPQ4G56', 3),
('VW Gol', 'UVW6I78', 5),
('Peueot 208', 'YZA7J89', null),
('Fiesta', 'FGH8L76', 7),
('Golf', 'TRE3M65', 9),
('Fusca', 'ASD3Q12', 8); 

create table atuacaoVendas(
codAtuacao int auto_increment primary key,
descricao varchar(255) not null
);

insert into atuacaoVendas(descricao) values
('Vendas de veículos novos'),
('Vendas de veículos usados'),
('Vendas de veículos antigos'),
('Financiamento de veículos'),
('Seguro e proteção veicular'),
('Manutenção e reparo de veículos'),
('Serviço de pós-vendas'),
('Consultoria de vendas'),
('Programações e eventos especiais');

create table indicacoes(
codIndicador int,
codIndicado int,
primary key(codIndicador, codIndicado),
foreign key (codIndicador) references funcionarios(codFunc),
foreign key (codIndicado) references funcionarios(codFunc)
);

insert into indicacoes(codIndicador, codIndicado) values
(1,2),
(1,3),
(2,4),
(2,5),
(4,6),
(7,3),
(9,7),
(8,9);

/*1. Crie uma função chamada `GetFuncionarioVeiculoCount` que recebe o código de um funcionário e retorna o 
número de veículos associados a esse funcionário.*/
Delimiter //
create function getFuncionarioVeiculoCount(id int) returns int
begin
declare veiculos int;
select count(*) into veiculos from veiculos where veiculos.codFunc = id limit 1;
return ifnull(veiculos, 0);
end // 
Delimiter ;

select getFuncionarioVeiculoCount(8)  as 'Quantidade de veículos' ;
select * from veiculos;

/*1. Crie um procedimento armazenado chamado `AddVenda` que insere uma nova atuação de vendas na tabela `AtuacaoVendas`.
 O procedimento deve receber uma descrição e adicionar a nova atuação de vendas.*/
delimiter //
create procedure addVenda(in id int, in descricao varchar(255))
begin
insert into atuacaoVendas(codAtuacao, descricao) values
(id, descricao);
end //
delimiter ;

select * from atuacaoVendas;
call addVenda(10, "Teste");


/*3. Crie um gatilho chamado `BeforeInsertIndicacao` que verifica se o funcionário indicado já foi indicado por outro funcionário. 
Se o funcionário já tiver uma indicação, o gatilho deve lançar um erro e impedir a inserção*/
delimiter //
create trigger beforeInsertIndicacao
before insert on indicacoes
for each row
begin
	if exists(select 1 from indicacoes where codIndicado = new.codIndicado)
    then
		signal sqlstate '45000' set message_text = 'O funcionário indicado já foi indicado por outro funcionário';
	end if;
end
// delimiter ;
 
insert into indicacoes (codIndicador, codIndicado) values (2, 8);

select * from indicacoes;

/*3. Crie uma visão chamada `FuncionarioVeiculoAtuacao` que exibe todos os funcionários, seus veículos e as atuações de vendas associadas.
 A visão deve mostrar os campos: código do funcionário, nome do funcionário, modelo do veículo, placas do veículo e descrição da atuação de vendas.*/
create view funcionarioVeiculoAtuacao as 
select f.codFunc as "ID do funcionário", f.nomeFunc as "Nome do funcionário", v.modelo as "Modelo do veículo", v.placas as "Placa do veículo", a.descricao as "Descriação da atuação vendas" from funcionarios f
inner join veiculos v on f.codFunc = v.codFunc 
inner join atuacaoVendas a on f.codAtuacao = a.codAtuacao;

select * from funcionarioVeiculoAtuacao;

/*3. Execute uma consulta para mostrar a lista completa de funcionários, indicando se eles têm veículos e quais atuações de vendas estão associadas a cada veículo, 
usando um `LEFT JOIN` para incluir todos os funcionários, mesmo aqueles sem veículos ou atuações de vendas.*/
select f.codFunc as "ID do funcionário", f.nomeFunc as "Nome do funcionário", v.modelo as "Modelo do veículo", a.descricao as "Atuação de vendas" from funcionarios f 
left join veiculos v on f.codFunc = v.codFunc
left join atuacaoVendas a on f.codAtuacao = a.codAtuacao;

