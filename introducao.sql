create database bd_fatec;
use bd_fatec;

create table alunos (
idAluno int auto_increment primary key,
nome varchar(100),
cpf varchar(14)); #aq vms utilizar varchar por conta dos pontos, mas o ideal é usar int p ocupar menos espeaço

insert into alunos (nome,cpf) values 
("Pedro", "123.456.789-01"),
("Lucas", "111.222.333-04"),
("Barbara", "222.333.444-05");

#seleção de todos os registros da tabela 
select * from alunos;

#seleção de id e nome somente
select idAluno, nome from alunos;

#seleção de id e cpf somente
select idAluno, cpf from alunos;

#seleção de cpf e nome somente
select cpf, nome from alunos;

#seleção de cpf, nome e idAluno
select cpf, nome, idAluno from alunos;

#seleção de tudo quando o id for do aluno 2 
select * from alunos where idAluno=2;

#atualizar dado
update alunos set cpf="111.222.333-44" where idAluno=2;