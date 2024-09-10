create database if not exists emptech;

use emptech;

create table if not exists funcionarios(
codFunc int auto_increment primary key,
nomeFunc varchar(255) not null
);

create table if not exists veiculos(
codVeic int auto_increment primary key,
modelo varchar(255) not null,
placas varchar(20) not null,
codFunc int
);

insert into funcionarios(nomeFunc) values
('João Silva'),
('Maria Oliveira'),
('Pedro Santos'),
('Ana Costa'),
('Lucas Almeida'),
('Fernanda Lima');

insert into veiculos(modelo, placas, codFunc) values
('Fiat Uno', 'ABC1D23', 1),
('Honda Civic', 'XYZ2E34', 1),
('Toyota Corolla', 'LMN3F45', 2),
('Chevrolet Onix', 'OPQ4G56', 3),
('VW Gol', 'UVW6I78', 5),
('Peueot 208', 'YZA7J89', null); 

#inner join
select f.nomeFunc as Nome, veiculos.modelo as Modelo from veiculos
inner join funcionarios f on veiculos.codFunc = f.codFunc;

#equi join
select f.nomeFunc as Nome, v.modelo from veiculos v  
join funcionarios f using(codFunc);

#left join: retorna todos os campos do lado esquerdo do Join que se relaciona com o lado direito, mais os registros que não que não relacionam com o lado direito e que sejam do lado esquerdo; a diferença é que trouxe o carro que não tem dono; listo tudo que tenha ou não relacionamento da tabelaA com a tabela tabelaB
select f.nomeFunc as Nome, v.modelo from veiculos v
left join funcionarios f using (codFunc);

#right join: retorna todos os campos do lado direito do Join que se relaciona com o lado esquerdo, mais os registros que não que não relacionam com o lado esquerdo e que sejam do lado direito; a diferença é que trouxe o carro que não tem dono; listo tudo que tenha ou não relacionamento da tabelaB com a tabela tabelaA
select f.nomeFunc as Nome, v.modelo from veiculos v
right join funcionarios f using (codFunc);

#full join:  o MySQL não tem o full, logo fazemos o LEFT E RIGHT na mesma query, porém utilizar o UNION; cruza os dados, ou seja, quem tem ou não da esquerda com a direita, e quem tem ou não da direita com a esquerda; posso fazer quantas UNION forem necessárias
select f.nomeFunc as Nome, v.modelo from veiculos v
left join funcionarios f using (codFunc)
union
select f.nomeFunc as Nome, v.modelo from veiculos v
right join funcionarios f using (codFunc);

#view: estrutura de seleção que encapsula querys complexas para simplificar o uso ao usuário e facilitar as chamdas em aplicações externas
create view func_veic as 
select f.nomeFunc as Nome, v.modelo from veiculos v
left join funcionarios f using (codFunc)
union
select f.nomeFunc as Nome, v.modelo from veiculos v
right join funcionarios f using (codFunc);

#chamando a view
select * from func_veic;

create table atuacaoVendas(
codAtuacao int auto_increment primary key,
descricao varchar(255) not null
);

insert into atuacaoVendas(descricao) values
('Vendas de veículos novos'),
('Vendas de veículos usados'),
('Manutenção e reparo de veículos'),
('Serviço de pós-vendas'),
('Consultoria de vendas'),
('Programações e eventos especiais');

#cross join: irá criar relatório onde irá fazer todas as combinações possíveis entre as tabelas; para cada linha da tabela esquerda queremos todos os linhas da tabelas direita ou vice-versa; ele também é chamado de produto cartesiano entre duas tabelas; porém, para isso é preciso que ambas tenham o campo em comum, para que a ligação exista entre as duas tabelas.
/*Ex: se cruzarmos as tabelas funcionario, veiculos e atuacaoVendas onde teremos F com 6 registros, V com & e AV com 6, iremos um resultado de combinação 6 X 7 X 6 que totalizará combinações*/

select f.codFunc as Funcionário, v.modelo as Modelo, v.placas as Placa, a.descricao as Descrição from funcionarios f
cross join veiculos v 
cross join atuacaoVendas a;

#autorelacionamento: quem indicou quem, no caso, funcionários
create table indicacoes(
codIndicador int,
codIndicado int,
primary key(codIndicador, codIndicado),
foreign key (codIndicador) references funcionarios(codFunc),
foreign key (codIndicado) references funcionarios(codFunc)
);

select * from indicacoes;

insert into indicacoes(codIndicador, codIndicado) values
(1,2),
(1,3),
(2,4),
(2,5),
(4,6);

#self join: gera um resultado de relacionamento de dados de uma tabela com ela mesma, ou seja, um auto-relacionamento
select i1.codIndicador as "ID indicador", f1.nomeFunc as "Nome indicador", 
i1.codIndicado as "ID indicado", f2.nomeFunc as "Nome indicado" from indicacoes i1
join funcionarios f1 on i1.codIndicador = f1.codFunc
join funcionarios f2 on i1.codIndicado = f2.codFunc;