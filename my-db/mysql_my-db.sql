-- title: DB - mySQL - praktika - mano db
-- v: 2021-03-27T1803 AU



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
)
;

-- Valome:
truncate table mokinys;

-- Pildome:
insert into mokinys values
  (1, 1, 'A', 'U')
, (2, NULL, 'A', 'D')
, (3, 1, 'M', 'R')
, (4, 3, 'G', 'G')
, (5, 3, 'K', 'K')
;

-- Tikriname:
select count(*) from mokinys;



-- # 4. Ruošiame vitriną

-- Tikriname:
select mokinys.klase_id
, count(*) as klases_mokiniu_kiekis
from mokinys
group by mokinys.klase_id
;
-- Pasigendame klasės pavadinimo ...

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



-- # 5. Lentelė 2: klase

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



-- # 6. ANALIZĖ

-- Tiriame: pagrindinė užklausa (galutinis rezultatas)
select
  k.pavadinimas as "klasės pavadinimas"
, m.klasiu_mokiniu_kiekis as "mokinių kiekis"
from klase as k
left join v__klasiu_mokiniu_kiekis as m on m.klase_id = k.id
where 1=1
  and m.klasiu_mokiniu_kiekis is not null
order by k.pavadinimas
;


-- Tiriame: mokiniai be klasių
select
  m.id as "mokinio nr"
, m.vardas
, m.pavarde
, m.klase_id
from mokinys as m
where 1=1
  and m.klase_id is null
;

-- Pildome trūkstamus duomenis vienam mokiniui:
update mokinys
set klase_id = 3
where id = 2
;

-- Tikriname:
select * from mokinys where id = 2;



-- Tiriame: klasės be mokinių
select
  k.pavadinimas as "klasės pavadinimas"
from klase as k
left join v__klasiu_mokiniu_kiekis as m on m.klase_id = k.id
where 1=1
  and m.klasiu_mokiniu_kiekis is null
order by k.pavadinimas
;



-- # 7. Išvados

/*
Paruoštas ir išbandytas `mysql` duomenų bazių valdymo sistemos kodas, kuris:

1) sukuria duomenų bazę: `mokykla`
2) sukuria lenteles: `mokinys` ir `klase`
3) įterpia dirbtinius duomenis
4) apjungia lenteles: `mokinys` ir `klase`
5) atlieka skaičiavimus: mokinių kiekį pagal klasę
6) sukuria vitriną: `v__klasiu_mokiniu_kiekis`
7) kreipiasi į duomenų bazę: `mokykla` per vitriną `v__klasiu_mokiniu_kiekis`
8) patikrina kiekvieną žingsnį
*/


-- # 8. Klausimai

/*
Kaip manote:

1) kas pirmas, `klasė` ar `moksleivis`?
2) įtraukti `modulius`, `lankomumą`, `atsiskaitymus` ir `įvertinimus`?
	* `modulis`:
		* data nuo-iki,
        * val. sk,
        * humanitarinis ar techninis
    * `lankomumas`:
		* mokinys [],
        * pamoka [],
        * data,
        * [lankomumas] = {taip=1/ne=0}
    * `tikrinimas`:
		* modulis [],
        * data,
        * [tikrinimo tipas] = {testas, teorija, praktika, namų darbai}
    * `vertinimas`:
		* modulis [],
        * tikrinimas [],
        * [vertinimo vertė] = {0..10}, galimi tušti
*/
