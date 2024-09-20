create database banco;
use banco;

create table clientes(
id int auto_increment primary key,
nome varchar(100),
email varchar(100)
);

create table contas(
id int auto_increment primary key,
clienteId int,
saldo decimal(10,2),
foreign key(clienteId) references clientes(id)
);

create table transacoes(
id int auto_increment primary key,
contaId int,
valor decimal(10,2),
dataTransacao datetime,
tipo_transacao enum("Depósito", "Saque", "Qual operação") default ("Qual operação"),
foreign key(contaId) references contas(id)
);

insert into clientes(nome, email) values
("João Silva", "joao@gmail.com"),
("Maria Santos", "maria@gmail.com"),
("Carlos Pereira", "carlos@gmail.com");

insert into contas(clienteId, saldo) values 
(1, 1000.00),
(2, 500.00),
(3, 1200.00);

/*1. Indexes: os índices em MySQL são usados para melhorar o desempenho das consultas, permitindo uma recuperação de dados mais rápida. 
Ele funcionam como índices em um livro, ajudando a localizar rapidamente as linhas sem ter que fazer uma busca completa na tabela.
	EXPLICAÇÃO BÁSICA: um índice cria uma estrutura de dados adicional que permite uma busca mais rápida, mas também ocupa espaço e 
    pode desacelerar a inserção e atualização de dados
*/

#exemplo 1: index em coluna frequentemente atualizada
#busca pelo nome
create index idx_cliente_nome on clientes(nome);
select * from clientes where nome = "João Silva";

#exemplo 2: index em colunas para busca completa
/* se as consultas frequentemente buscam por combinações de saldo e clienteId, criar um índice pode melhorar o desempenho; localização melhor*/
create INDEX idx_cliente_saldo on contas(clienteId, saldo);
select * from contas where clienteId = 1 and saldo > 500;

#exemplo 3: index para melhorar o order by
/* ao usar ORDER BY em uma coluna específica, o uso de índices pode acelerar o processo de ordenação */

#inserindo dados na tabela transações
insert into transacoes(contaId, valor, dataTransacao, tipo_transacao) values
(1, 500.00, "2024-09-18 10:00:00", "Depósito"),
(1, 200.00, "2024-09-18 11:00:00", "Saque"),
(2, 300.00, "2024-09-18 12:00:00", "Depósito");

create index idx_transacoes_data on transacoes(dataTransacao);
select * from transacoes order by dataTransacao desc;

#listar indexes

show index from clientes;
show index from transacoes;

#transaction 
/*transições permitem que um conjunto de operações seja tratado como uma unica unidade de trabalho, 
garantindo que todas sejam executadas com sucesso ou que nenhuma seja aplicada, no caso de falhas
begin 
commit 
rollback

exeplo 1: transferencia de saldo entre contas, onde ambas as atualizações precisam ocorrer ou nenhuma delas. 
*/

start transaction;
update contas set saldo = saldo - 100 where id =1;
update contas set saldo = saldo + 100 where id =2;
select * from contas;
commit;
rollback;
select * from contas;

/* se houver qualquer um erro em qualquer dos updates, o sistema deve fazer um rollback para desfazer as alterações*/