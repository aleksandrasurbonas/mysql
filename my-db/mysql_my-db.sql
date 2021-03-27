-- title: DB - mySQL - praktika - mano db
-- v: 2021-03-27T1611 AU



-- # 1. DB kūrimas - Mokykla

-- Kuriame, jei nėra:
drop database  if exists  mokykla;

-- Triname, jei yra:
create database  if not exists  mokykla;



-- # 2. DB pasirinkimas:
use mokykla;



-- # 3. Lentelė 1 - Mokinys

-- Triname, jei yra:
drop table  if exists  mokinys;

-- Kuriame, jei nėra:
create table  if not exists  mokinys(
  id       int primary key -- mokinio numeris
, klase_id int             -- mokinio klasės id
, vardas   char(1)         -- mokinio vardo pirma raidė
, pavarde  char(1)         -- mokinio pavardės pirma raidė
);

-- Pildome:
insert into mokinys values
  (1, 1, 'A', 'U')
, (2, 1, 'A', 'D')
, (3, 1, 'M', 'R')
;

-- Tikriname:
select count(*) from mokinys;



-- -------------------------------------------
-- 4. # Ruošiame vitriną (`VIEW`)
-- -------------------------------------------
-- Tikriname:
select mokinys.klase_id
, count(*) as klases_mokiniu_kiekis
from mokinys
group by mokinys.klase_id
;

-- Triname, jei yra:
drop view if exists v__klasiu_mokiniu_kiekis;

-- Kuriame pagal pavyzdį:
create view v__klasiu_mokiniu_kiekis as 
  select mokinys.klase_id
  , count(*) as klasiu_mokiniu_kiekis
  from mokinys
  group by mokinys.klase_id
;

-- Tikriname:
select * from v__klasiu_mokiniu_kiekis;


-- -------------------------------------------
-- # 5. Lentelė 2: klase
-- -------------------------------------------

-- Triname, jei yra:
drop table  if exists  klase;

-- Kuriame, jei nėra:
create table  if not exists  klase(
  id          int primary key -- klasės id
, tipas_id    char(1)         -- klasės tipo id: H (humanitarai), T (tiksliukai)
, pavadinimas char(10)        -- klasės pavadinimas
)
;

-- Pildome:
insert into klase values
  (1, 'T', 'CDM')
, (2, 'H', 'LRT')
, (3, 'T', 'BD9')
, (4, 'T', 'PY8')
, (5, 'T', 'R2')
;

-- Tikriname:
select count(*) as counter from klase;



-- -------------------------------------------
-- # ANALIZĖ
-- -------------------------------------------

-- Tiriame:
select
  k.pavadinimas as "klasės pavadinimas"
, m.klasiu_mokiniu_kiekis as "mokinių kiekis"
from klase as k
left join v__klasiu_mokiniu_kiekis as m on m.klase_id = k.id
where 
  -- m.klasiu_mokiniu_kiekis is null
  m.klasiu_mokiniu_kiekis is not null
  -- k.pavadinimas = 'CDM'
;



-- KAIP MANOTE, KAS PIRMAS: KLASĖ AR MOKSLEIVIS :) --
