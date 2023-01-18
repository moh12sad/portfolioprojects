select * 
from dbo.coviddeath
where continent  <>' ' ;

select *
from dbo.coviddeath
where location like'%egypt%' and continent  <>' ' ;

select location , date ,new_cases, total_cases,case when total_cases = 0 then null else (new_cases/total_cases)*100 end newcasespercentage
from dbo.coviddeath
where location like'%egypt%' and continent  <>' ' ;

select location , date ,total_deaths, total_cases,case when total_cases = 0 then null else (total_deaths/total_cases)*100 end deathpercentage
from dbo.coviddeath
where location like'%egypt%' and continent  <>' ' ;

select location ,population,max(total_cases) max_cases,max((total_cases/ISNULL(nullif(population,0),1)))*100 deathpercentage
from dbo.coviddeath
--where location like'%egypt%'
where continent  <>' ' 
group by location ,population
order by 4 desc

select location ,max(total_deaths) totaldeathcount
from dbo.coviddeath
--where location like'%egypt%'
where continent  <>' ' 
group by location
order by 2 desc

select continent ,max(total_deaths) totaldeathcount
from dbo.coviddeath
--where location like'%egypt%'
where continent <>' '
group by continent
order by 2 desc

select sum(total_deaths) total_death , sum(total_cases) total_cases,(sum(total_deaths)/sum(total_cases))*100 precetage_death
from dbo.coviddeath
--where location like'%egypt%'
where continent <>' '
--group by totaldeathcount
order by 2 desc


select * from dbo.covidvaccinaion

select cd.continent continen, cd.location locat,cd.date date_n,cd.population popul,cv.new_vaccinations new_cav,
sum(cast(cv.new_vaccinations as bigint)) over (partition by cd.location order by cd.location ,cd.date)totalnewcav
from dbo.coviddeath cd
join dbo.covidvaccinaion cv
on cd.location = cv.location and cd.date= cv.date
where cd.continent <>' '
order by 2,3

select *
from (
select continent_,location_,population_,max(totalnewcav) total_vac,(max(totalnewcav)/population_)*100 vac_pop_per
from (select cd.continent continent_, cd.location location_,cd.date date_n,cd.population population_,cv.new_vaccinations new_cav,
sum(cast(cv.new_vaccinations as bigint)) over (partition by cd.location order by cd.location ,cd.date)totalnewcav
from dbo.coviddeath cd
join dbo.covidvaccinaion cv
on cd.location = cv.location and cd.date= cv.date
where cd.continent <>' '
) total_new_cav
group by continent_,location_,population_
--order by 1,2
) percetagepopulationvaccination

create view percetagepopulationvaccination as
select continent_,location_,population_,max(totalnewcav) total_vac,(max(totalnewcav)/population_)*100 vac_pop_per
from (select cd.continent continent_, cd.location location_,cd.date date_n,cd.population population_,cv.new_vaccinations new_cav,
sum(cast(cv.new_vaccinations as bigint)) over (partition by cd.location order by cd.location ,cd.date)totalnewcav
from dbo.coviddeath cd
join dbo.covidvaccinaion cv
on cd.location = cv.location and cd.date= cv.date
where cd.continent <>' '
) total_new_cav
group by continent_,location_,population_
--order by 1,2

select *
from percetagepopulationvaccination