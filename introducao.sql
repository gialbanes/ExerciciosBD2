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

#adicionar campos na tabela
alter table alunos add column rg varchar(13);
alter table alunos add column tel varchar(14);
select * from alunos;

#trocar tel para cel; comando CHANGE
alter table alunos change tel cel varchar(14);
select * from alunos;

#excluir o cmapo rg
alter table alunos drop column rg;
select * from alunos;

#apelidos de campos; quero mudar na exibição da atabela e não no bd; aspas: por cota dos espaços;
select idAluno as ID, nome as "Nome do aluno", cpf as CPF, cel as Telefone from alunos; 

#apelido de tabela; no apelido de tabela não tenho o "as"; esse modelo é para casos em que há duas tabelas em que o nome do atributo é o mesmo;
select alunos.nome, alunos.cpf from alunos;
# ou assim: select a.nome, a.cpf from alunos a;

create table disciplinas(
idDisci int auto_increment primary key,
nomeDisc varchar(100)
);

insert into disciplinas (nomeDisc) values
("Banco de dados relacional"),
("Desenvolvimento web II"),
("Design digital");

#relacionamento
create table matricula(
idMatricula int auto_increment primary key,
aluno int,
disciplina int,
#criar chave estrangeira 
constraint fk_aluno_disciplina foreign key (aluno) references alunos(idAluno),
foreign key(disciplina) references disciplinas(idDisci) #outra maneira de fazer, mas é melhor o de cima
);

insert into matricula (aluno, disciplina) values
(1,1),
(1,2),
(1,3),
(2,1),
(2,3),
(3,1);

select * from matricula;

select aluno, disciplina from matricula where aluno=1;

#aqui vai falhar pq nao existe aluno 4 e disciplina 5 inseridos no bd; só seriam inseridos se não houvesse chave estrangeira
insert into matricula (aluno, disciplina) values
(4,5),
(4,1);

#substituindo os ids pelo nome de fato na visualização com inner join
select a.nome as "Nome do aluno", d.nomeDisc as "Nome da disciplina" from matricula
inner join alunos a on matricula.aluno = a.idAluno
inner join disciplinas d on matricula.disciplina = d.idDisci;

