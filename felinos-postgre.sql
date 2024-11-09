CREATE TABLE gatos (
    IdGato SERIAL PRIMARY KEY,
    Nome VARCHAR(50),
    Raca VARCHAR(50),
    Coloracao VARCHAR(50),
    Idade INT,
    BrinquedoFavorito VARCHAR(50)
);

INSERT INTO gatos (Nome, Raca, Coloracao, Idade, BrinquedoFavorito) VALUES
( 'Mickey', 'Maine Coon', 'Multicor', 3, 'Bolinha vermelha' ),
( 'Nine', 'Ragamuffin', 'Bege', 2, 'Bolinha verde' ),
( 'Carmen', 'Persian', 'Marrom', 2, 'Ratinho de borracha' ),
( 'Luna', 'Abyssinian', 'Multicor', 12, 'Bolinha de papel' ),
( 'Bella', 'Siamese', 'Laranja', 15, 'Arranhador' ),
( 'Simba', 'Bengal', 'Amarelo com Manchas', 5, 'Corda' ),
( 'Nina', 'Sphynx', 'Pele Nua', 4, 'Bolinha de Lã' ),
( 'Zorro', 'Persian', 'Cinza', 10, 'Ratinho de Borracha' ),
( 'Chester', 'British Shorthair', 'Cinza', 7, 'Pneu de Borracha' ),
( 'Tina', 'Maine Coon', 'Branco e Preto', 8, 'Peixe de Borracha' );

/*1) Crie uma consulta para listar a média de idade dos gatos agrupados pela raça, 
mostrando também a quantidade de gatos por raça. Ordene os resultados pela 
média de idade, da raça mais velha para a mais nova.*/
create view view_media_idade as
select raca as Raca, count(*) as "Quantidade de gatos", round(avg(idade), 0) as Media from gatos  
group by raca
order by Media desc;

select * from view_media_idade;

/*2) Crie uma consulta para listar o nome e a idade dos gatos cujo brinquedo favorito é 
"Ratinho de Borracha" ou "Bolinha de Lã", e que possuem uma idade maior que a 
média de idade de todos os gatos.*/
select nome, idade from gatos 
where BrinquedoFavorito in ('Ratinho de Borracha', 'Bolinha de Lã')
and idade > (select round(avg(idade), 0) from gatos);

/*3) Crie uma consulta para listar os gatos que têm mais de 5 anos de idade e que têm 
como brinquedo favorito "Ratinho de Borracha", ordenando os resultados por 
idade, da mais velha para a mais nova.*/
select nome, idade, BrinquedoFavorito from gatos
where idade > 5 and BrinquedoFavorito = 'Ratinho de Borracha'
order by idade desc;

