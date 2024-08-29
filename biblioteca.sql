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

insert into usuarios (nomeCompleto, endereco, bairro, cidade, UF, assinatura) values
('Ana Silva', 'Rua das Flores, 123', 'Jardim Primavera', 'São Paulo', 'SP', 'Aluno'),
('João Souza', 'Avenida Central, 456', 'Centro', 'Rio de Janeiro', 'RJ', 'Professor'),
('Maria Oliveira', 'Praça da Liberdade, 789', 'Liberdade', 'Belo Horizonte', 'MG', 'Funcionario');

insert into usuariosXtelefone (codUsuario, telefone) values
(1,11987654321),
(2, 21987654321 ),
(3, 31987654321);

select * from usuariosXtelefone;

insert into usuariosXemails (codUsuario, email) values
(1, 'ana.silva@example.com'),
(2, 'joao.souza@example.com'),
(3, 'maria.oliveira@example.com');

alter table emprestimos add column codUsuario int,
add constraint  fk_codUsuario_emprestimos foreign key(codUsuario) references usuarios(codUsuario);

insert into emprestimos (dtEmprestimo, dtPrevistaDevolucao, dtRealDevolucao, codUsuario) values
('2024-08-01', '2024-08-15', NULL, 1),
('2024-08-05', '2024-08-20', NULL, 2),
('2024-08-10', '2024-08-25', NULL, 3);

insert into emprestados (codLivro, codEmprestimo) values 
(1,1),
(2,2),
(3,3);


#1. Listar todos os livros disponíveis na biblioteca
select * from livros;

#2. Encontrar todos os autores que têm mais de 50 anos
select * from autores;
SELECT nomeCompleto, FLOOR(DATEDIFF(CURDATE(), dataNasc) / 365) AS idade FROM autores WHERE FLOOR(DATEDIFF(CURDATE(), dataNasc) / 365) > 50;


#3. Mostrar todos os usuários que têm assinatura de 'Professor'
select * from usuarios where assinatura='Professor';

#4. Listar todos os emprestimos que ainda não foram devolvidos.
select * from emprestimos;
SELECT codEmprestimo, dtEmprestimo, dtPrevistaDevolucao, TIMESTAMPDIFF(DAY , dtEmprestimo, dtPrevistaDevolucao) AS 'DIAS MÁX DE EMPRÉSTIMO' FROM emprestimos WHERE TIMESTAMPDIFF(DAY, dtEmprestimo, dtPrevistaDevolucao) = 15;

#5. Exibir todos os livros junto com os nomes dos autores que os escreveram.
select l.titulo as Livro, a.nomeCompleto as Autor from livrosxautores
inner join livros l on livrosxautores.codLivro = l.codLivro
inner join autores a on livrosxautores.codAutor = a.codAutor;

