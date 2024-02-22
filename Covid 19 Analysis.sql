-- Total cases, total deaths for each country
Select location, max(total_cases), max(total_deaths)
from coviddeaths
where continent is not null
group by 1
order by 2 desc; 

-- Likelihood of dying if you contract covid in a country
Select location, max(total_cases), max(total_deaths), (max(total_deaths) / max(total_cases)*100) as Death_percentage  
from coviddeaths
where continent is not null 
group by 1
order by 4 desc;

-- Total cases with respect to population
select location, population, max(total_cases), max(total_deaths), max(total_cases/population*100) Percent_of_population_infection
from coviddeaths
where continent is not null
group by 1,population
order by 5 desc;

-- Highest death count per population by country
Select location, population, max(total_deaths), max(total_deaths/population*100) death_count_per_population
from coviddeaths
group by location, population
order by 4 desc;

-- Total death count by continent
select continent, max(total_deaths)
from coviddeaths
where continent is not null
group by continent
order by 2 desc;

-- Global cases per date
Select date, Sum(new_cases) as total_cases,Sum(new_deaths) as total_deaths,Sum(new_deaths)/Sum(new_cases)*100 as Death_percentage  
from coviddeaths
group by date
order by 3 desc;

-- Total cases,deaths and death percentage until now

Select Sum(new_cases) as total_cases,Sum(new_deaths) as total_deaths,Sum(new_deaths)/Sum(new_cases)*100 as Death_percentage  
from coviddeaths;

-- Rolling count of vaccinations
Select d.continent, d.location, d.date, v.new_vaccinations,
sum(v.new_vaccinations) over (PARTITION BY d.location order by d.location,d.date ) as Rolling_Count_Vacination
from coviddeaths as d
JOIN covidvaccinations as v
on d.location = v.location
and d.date = v.date
where d.continent is not null;

-- Percentage of population vacinated

With popvsvac 
as
(
Select d.continent, d.population, d.location, d.date, v.new_vaccinations,
sum(v.new_vaccinations) over (PARTITION BY d.location order by d.location,d.date ) as Rolling_Count_Vacination
from coviddeaths as d
JOIN covidvaccinations as v
on d.location = v.location
and d.date = v.date
where d.continent is not null
)
select * , (Rolling_Count_Vacination/population)*100 
from popvsvac;

-- View of Percent of population vacinated

Create view percentpopulationvacinated as
Select d.continent, d.population, d.location, d.date, v.new_vaccinations,
sum(v.new_vaccinations) over (PARTITION BY d.location order by d.location,d.date ) as Rolling_Count_Vacination
from coviddeaths as d
JOIN covidvaccinations as v
on d.location = v.location
and d.date = v.date
where d.continent is not null;

-- View of cases by continent

Create view cases_by_continent as
select continent, max(total_deaths)
from coviddeaths
where continent is not null
group by continent
order by 2 desc;
 