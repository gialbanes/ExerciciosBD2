create database biblioteca;
use biblioteca;

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

create table emprestados (
idx int auto_increment primary key,
codLivro int,
codEmprestimo int,
constraint fk_codLivro_emprestado foreign key(codLivro) references livros(codLivro),
constraint fk_codEmp_emprestado foreign key(codEmprestimo) references emprestimos(codEmprestimo)
);

insert into livros (ISBN, titulo, subtitulo, ano, genero, descricao) values
(9780140449136, 'A Odisséia', 'Traduzido por: João Pereira', 800, 'Épico', 'A história épica 
de Odisseu e sua jornada de volta para casa.' ),

(9780321125217, 'Clean Code', 'A Handbook of Agile Software Craftsmanship', 2008 , 'Tecnologia', 
'Conselhos e melhores práticas para escrever código limpo e manutenível.'),

(9780201616224, 'Design Patterns', 'Elements of Reusable Object-Oriented Software', 1994, 
'Tecnologia', 'Padrões de design de software e suas aplicações em programação orientada a 
objetos.' );

select * from livros;

insert into autores (nomeCompleto, dataNasc, biografiaResumida) values
('Homero', '0800-01-01', 'Poeta grego da Antiguidade, autor da Ilíada e da Odisséia.'),
('Robert C. Martin', '1952-12-05', 'Engenheiro de software e autor conhecido por seu trabalho em princípios de design de software.'),
('Erich Gamma', '1960-03-22', 'Um dos autores do famoso livro "Design Patterns", professor e consultor em design de software.'),
('teste', '2015-03-02', 'testando');

select * from autores;

insert into livrosXautores (codLivro, codAutor) values
(1,1), 
(2,2),
(3,3);

select * from livrosxautores;

insert into usuarios (nomeCompleto, endereco, bairro, cidade, UF, assinatura) values
('Ana Silva', 'Rua das Flores, 123', 'Jardim Primavera', 'São Paulo', 'SP', 'Aluno'),
('João Souza', 'Avenida Central, 456', 'Centro', 'Rio de Janeiro', 'RJ', 'Professor'),
('Maria Oliveira', 'Praça da Liberdade, 789', 'Liberdade', 'Belo Horizonte', 'MG', 'Funcionario');

select * from usuarios;

insert into usuariosXtelefone (codUsuario, telefone) values
(6,11987654321),
(7, 21987654321 ),
(8, 31987654321);

select * from usuariosXtelefone;

insert into usuariosXemails (codUsuario, email) values
(6, 'ana.silva@example.com'),
(7, 'joao.souza@example.com'),
(8, 'maria.oliveira@example.com');

select * from usuariosxemails;

insert into emprestimos (dtEmprestimo, dtPrevistaDevolucao, dtRealDevolucao, codUsuario) values
('2024-08-01', '2024-08-15', NULL, 6),
('2024-08-05', '2024-08-20', NULL, 7),
('2024-08-10', '2024-08-25', NULL, 8);

select * from emprestimos;

insert into emprestados (codLivro, codEmprestimo) values 
(1,7),
(2,8),
(3,9);

select * from emprestados;

#1. Listar todos os livros disponíveis na biblioteca
select * from livros;

#2. Encontrar todos os autores que têm mais de 50 anos
select nomeCompleto as Autor, FLOOR(DATEDIFF(CURDATE(), dataNasc) / 365) as Idade from autores where FLOOR(DATEDIFF(CURDATE(), dataNasc) / 365) > 50;


#3. Mostrar todos os usuários que têm assinatura de 'Professor'
select * from usuarios where assinatura='Professor';

#4. Listar todos os emprestimos que ainda não foram devolvidos. 
select e.codEmprestimo as Empréstimo, dtEmprestimo as 'Data de empréstimo', dtRealDevolucao as 'Data real de devolução' from emprestados ep
inner join emprestimos e on ep.codEmprestimo = e.codEmprestimo 
where dtRealDevolucao is null;

#5. Exibir todos os livros junto com os nomes dos autores que os escreveram.
select l.titulo as Livro, a.nomeCompleto as Autor from livrosxautores
inner join livros l on livrosxautores.codLivro = l.codLivro
inner join autores a on livrosxautores.codAutor = a.codAutor;

#6. Mostrar todos os empréstimos com o nome do usuário que fez o empréstimo e o título do livro emprestado.
select e.codEmprestimo as Empréstimo, u.nomeCompleto as Usuario, l.titulo as Livro from emprestimos e
inner join emprestados ep on e.codEmprestimo = ep.codEmprestimo
inner join usuarios u on e.codUsuario = u.codUsuario
inner join livros l on ep.codLivro = l.codLivro;

#7. Listar todos os usuários e seus números de telefone.
select u.nomeCompleto as Usuario, telefone from usuariosxtelefone
inner join usuarios u on usuariosxtelefone.codUsuario = u.codUsuario;

#8. Mostrar todos os e-mails dos usuários que têm assinatura 'Funcionario'.
select u.nomeCompleto as Usuario, email as Email from usuariosxemails
inner join usuarios u on usuariosxemails.codusuario = u.codUsuario where assinatura = 'Funcionário';

#9.Encontrar todos os livros publicados após 2000 e ordená-los pelo ano de publicação. 
select titulo as Título, subtitulo as Subtítulo, ano as 'Ano de publicação' from livros order by ano desc;

#10. Listar todos os autores cuja biografia contém a palavra 'design'.
select nomeCompleto as Autor, biografiaResumida as Biografia from autores where biografiaResumida like '%_design_%';

#11. Mostrar os detalhes dos empréstimos que foram feitos por usuários da cidade 'São Paulo'.
select u.nomeCompleto as Usuario , u.cidade as Cidade, l.titulo as Livro, dtEmprestimo as 'Data do empréstimo', dtPrevistaDevolucao as 'Data prevista de devolução', 
dtRealDevolucao as 'Data real de devolução' from emprestimos e
inner join emprestados ep on e.codEmprestimo = ep.codEmprestimo
inner join livros l on ep.codLivro = l.codLivro
inner join usuarios u on e.codUsuario = u.codUsuario where cidade = 'São Paulo';

#12.Contar o número de livros de cada gênero na biblioteca.
select genero as Gênero, count(*) as 'Quantidade de livros' from livros group by genero;

#13. Encontrar o autor com o maior número de livros na biblioteca.
insert into livros (ISBN, titulo, subtitulo, ano, genero, descricao) values
(1234567891234, 'Teste', 'Teste', 900, 'Teste', 'Teste para o exercício 13');

insert into livrosXautores (codLivro, codAutor) values
(13,1);

select a.nomeCompleto as Autor, count(*) as 'Quantidade de livros' from livrosxautores
inner join autores a on livrosxautores.codAutor = a.codAutor
group by a.nomeCompleto;

#14. Mostrar todos os usuários que nunca fizeram um empréstimo.
select * from emprestimos where codusuario is null;

#15.Listar os livros que foram emprestados, mas ainda não foram devolvidos.
select l.titulo as Livro, dtEmprestimo as 'Data de empréstimo', dtRealDevolucao as 'Data real de devolução' from emprestados ep
inner join livros l on ep.codLivro = l.codLivro
inner join emprestimos e on ep.codEmprestimo = e.codEmprestimo
where e.dtRealDevolucao is null;


