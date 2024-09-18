create database if not exists loja_online;
use loja_online;
create table categorias (
id int auto_increment primary key,
nome varchar(50) not null
);
create table produtos(
id int auto_increment primary key,
nome varchar(100) not null,
categoria_id int,
preco decimal(10,2),
quantidade_estoque int,
foreign key (categoria_id) references categorias(id)
);
#inserção de dados
insert into categorias (nome) values
('Roupas'),('Calçados'),('Acessórios');
 
insert into produtos (nome, categoria_id, preco, quantidade_estoque) values
('Camiseta', 1, 29.99, 100),
('Calça Jeans', 1, 49.99, 75),
('Tênis Esportivo', 2, 89.99, 50),
('Relógio', 3, 199.99, 20),
('Óculos de Sol', 3, 129.99, 30),
('Jaqueta', 1, 79.99, 40),
('Bota', 2, 119.99, 25),
('Mochila', 3, 59.99, 60),
('Camisa Polo', 1, 39.99, 80),
('Tênis Casual', 2, 69.99, 70);
 
#ordenacao -  order by
select nome, preco from produtos order by preco asc;
select nome, preco from produtos order by nome;
select nome, preco from produtos order by preco desc;
 
#agrupamentos - group by
# agrupa linhas que tem valores iguais
 
select categorias.nome "Categoria", count(produtos.id) "Total de produtos" from produtos
join categorias on produtos.categoria_id = categorias.id
group by categorias.nome;
 
#calcular a media de preco dos produtos em cada categoria
select categorias.nome "Categorias", round(avg(produtos.preco),2) "Media de preço" from produtos
join categorias on produtos.categoria_id = categorias.id
group by categorias.nome;
 
/*Condição em Grupos (having) - É usada para filtrar os resultados que usa GROUP BY
Ela é similar ao WHERE, mas é aplicada apos a agragação dos dados, permitindo filtrar
grupos em vez de linhas individuais*/
 
#Encontrar categorias com mais de 3 produtos
select categorias.nome "Categorias", count(produtos.id) "Total de produtos" from produtos
join categorias on produtos.categoria_id = categorias.id
group by categorias.nome 
having count(produtos.id) > 3;
 
#Encontrar categorias onde a média de preço é superior a 50
select categorias.nome "Categorias", round(avg(produtos.preco),2) "Media de preço" from produtos
join categorias on produtos.categoria_id = categorias.id   
group by categorias.nome 
having avg(produtos.preco) > 50.0;
 
/*Paginação - Refere-se ao processo de dividir um conjunto de resultados em páginas menores,
geralmente para melhorar a performance e a usabilidade em interfaces. Em SQL, isso é feito usando clausulas
como LIMIT e OFFSET
Limit -> Quantidade de Registros a serem mostrados
OFFSET -> QUantidade de Registros a serem pulados*/
 
select * from produtos order by preco;
 
#Pagina 1:
select produtos.nome as "Produto", produtos.preco as "Preço", categorias.nome as "Categoria" from produtos
join categorias on produtos.categoria_id = categorias.id
order by produtos.preco
limit 3 offset 0;
 
#Pagina 2:
select produtos.nome as "Produto", produtos.preco as "Preço", categorias.nome as "Categoria" from produtos
join categorias on produtos.categoria_id = categorias.id
order by produtos.preco
limit 3 offset 3;
 
#Pagina 3:
select produtos.nome as "Produto", produtos.preco as "Preço", categorias.nome as "Categoria" from produtos
join categorias on produtos.categoria_id = categorias.id
order by produtos.preco
limit 3 offset 6;
 
#Pagina 4:
select produtos.nome as "Produto", produtos.preco as "Preço", categorias.nome as "Categoria" from produtos
join categorias on produtos.categoria_id = categorias.id
order by produtos.preco
limit 3 offset 9;