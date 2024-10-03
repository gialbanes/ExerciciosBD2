--para executar alt + f5

create table autores(
	autor_id serial primary key, --serial é o mesmo que int auto_increment
	nome varchar(100)
);

create table livros(
	livro_id serial primary key,
	titulo varchar(150),
	autor_id int references autores(autor_id) on delete cascade, --caso não detanha, ele deleta aquele registro
	estoque int check(estoque >= 0), --valida que o estoque não pode ser negativo
	ano_publicacao int, 
	isbn varchar(13) unique --determina que o registro será único
);

create table membros(
	membro_id serial primary key, 
	nome varchar(100),
	endereco varchar(100),
	email varchar(100),
	data_cadastro date default current_date
);

create table emprestimos(
	emprestimo_id serial primary key, 
	livro_id int references livros(livro_id),
	membro_id int references membros(membro_id),
	data_emprestimo date default current_date,
	data_devolucao date, 
	devolvido boolean default false, 
	data_prevista_devolucao date
);

create table reservas(
	reserva_id serial primary key, 
	livro_id int references livros(livro_id),
	membro_id int references membros(membro_id),
	data_reserva date default current_date
);

create table multas(
	multa_id serial primary key,
	emprestimo_id int references emprestimos(emprestimo_id),
	valor numeric(5,2),
	pago boolean default false
); 

-- Procedures e Triggers: gerar multa automaticamente para livros entregues atrasados --

-- procedure para calcular multa: 1.50 por dia de atraso --
CREATE OR REPLACE FUNCTION gerar_multa() 
RETURNS trigger AS $$ --$$: papel do delimiter 
BEGIN
    IF NEW.devolvido = TRUE AND NEW.data_devolucao > NEW.data_prevista_devolucao THEN 
        INSERT INTO multas(emprestimo_id, valor) 
        VALUES (NEW.emprestimo_id, (NEW.data_devolucao - NEW.data_prevista_devolucao) * 1.50);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;  --volta pra lingaugem do postgree, sql 

-- trigger que chama a procedure gerar_multa() ao devolver o livro
create trigger trigger_gerar_multa after update of devolvido on emprestimos for each row
when (new.devolvido=True)
execute function gerar_multa();

-- views para listar membros com emprestimos em atraso
create view emebros_em_atraso as 
select m.membro_id, m.nome, e.data_prevista_devolucao
from membros m 
join emprestimos e on m.membro_id = e.membro_id
where e.devolvido = false and e.data_prevista_devolucao < current_date;

-- indice para acelear consultas por titulo de livro
create index idx_livros_titulo on livros(titulo);

-- populando o banco de dados
insert into autores(nome) values
('J.K.Rowling'), ('George R.R. Martin'), ('J.R.R.Tolkien');

insert into livros(titulo, autor_id, estoque, ano_publicacao, isbn) values
('Harry Potter e a pedra filosofal', 1, 5, 1997, '9780747532699'),
('Game of Thrones', 2, 3, 1996, '9780553103504'),
('O senhor dos anéis', 3, 4, 1954, '9780618640157');


insert into membros(nome, endereco, email) values
('João Silva', 'Rua das Flores, 123', 'joao@email.com'),
('Maria Souza', 'Av. Brasil, 456', 'maria@email.com');

insert into emprestimos(livro_id, membro_id, data_prevista_devolucao) values
(1, 1, '2024-10-08'),
(2, 2, '2024-10-10');

select * from autores;
select * from livros;
select * from membros;
select * from emprestimos;
select * from multas;

update emprestimos set data_devolucao='2024-10-25', devolvido='true'
where emprestimo_id=1;

create or replace function baixar_estoque()
returns trigger as $$
declare diminuir_estoque int;
begin
	select estoque into diminuir_estoque from livros l where l.livro_id = new.livro_id;
	
	update livros set estoque = diminuir_estoque - 1
	where livro_id  = new.livro_id;
	return new;
end;
$$ language plpgsql;

create or replace function aumentar_estoque()
returns trigger as $$
declare novo_estoque int;
begin
	select estoque into novo_estoque from livros l where l.livro_id = new.livro_id;
	
	update livros set estoque = novo_estoque + 1
	where livro_id  = new.livro_id;
	return new;
end;
$$ language plpgsql;

create trigger trigger_baixar_estoque after insert on emprestimos for each row
execute functon baixar_estoque();

create trigger trigger_aumentar_estoque after 

