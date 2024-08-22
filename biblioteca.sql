create database bilioteca;
use bilioteca;

create table livros(
codLivro int auto_increment primary key,
ISBN int(13),
titulo varchar(255),
subtitulo varchar(255),
ano int(4),
genero varchar(100),
descricao varchar(255)
);

create table autores(
codAutor int auto_increment primary key,
nomeCompleto varchar(255),
dataNasc date,
biografiaResumida varchar(255)
);

create table livrosXautores(
idx int auto_increment primary key,
codLivro int,
codAutor int,
constraint fk_codLivro foreign key(codLivro) references livros(codLivro),
constraint fk_codAutor foreign key(codAutor) references autores(codAutor)
);

create table usuarios(
codUsuario int auto_increment primary key,
nomeCompleto varchar(255),
endereco varchar(255),
bairro varchar(100),
cidade varchar(100),
UF varchar(2)
);

alter table usuarios add column assinatura enum("Aluno", "Professor", "Funcionário") default "Aluno"; #ENUM: é usado para limitar os valores possíveis a um conjunto específico; #DEFAULT: se nenhum valor for preenchido, preenche automaticamente como aluno;
insert into usuarios(nomeCompleto, assinatura) values
("Robson", "Diretor"),
("Giovana", "Aluno");
select * from usuarios;

alter table usuarios change assinatura assinatura enum("Aluno", "Professor", "Funcionário", "Diretor") default "Aluno";

create table usuariosXtelefone(
idx int auto_increment primary key,
codUsuario int,
telefone int(11),
constraint fk_codUsuario foreign key(codUsuario) references usuarios(codUsuario)
);

create table usuariosXemails(
idx int auto_increment primary key,
codUsuario int,
email varchar(255),
constraint fk_codUsuarioEmails foreign key(codUsuario) references usuarios(codUsuario)
);

create table emprestimos(
codEmprestimo int auto_increment primary key,
dtEmprestimo date not null,
dtPrevistaDevolucao date not null,
dtRealDevolucao date
);



