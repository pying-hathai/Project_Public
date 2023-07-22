select * 
from CovidDeaths
order by 3,4

select *
from CovidVaccinations
order by 3,4

-- Select Data that we are going to be using

select 
	location, 
	date, 
	total_cases,
	new_cases,
	total_deaths,
	population
from CovidDeaths
order by 1,2

-- Looking at total case vs total deaths
-- Shows likelihood of dying if you contract covid in your country

select 
	location,
	date,
	total_cases,
	total_deaths,
	(total_deaths/total_cases)*100
from CovidDeaths
--where location like '%state%'
order by 1,2

-- Looking at the Totla cases vs totla population
-- Shows what percentage of population got covid

select 
	location,
	date,
	total_cases,
	population,
	(total_deaths/population)*100 as DeathPercentage
from CovidDeaths
where location like '%state%'
order by 1,2

-- Looking at country with highest inflection rate compared to population

select 
	location,
	population,
	MAX(total_cases) as HighestInfectionCount,
	Max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths
--where location like '%state%'
group by location, population
order by 4 DESC

-- Showing Country with highest death count per population

select 
	location,
	MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%state%'
group by location
order by 2 DESC

-- LET'S BREAK THINGS DOWN BY CONTIENT

select 
	continent,
	MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%state%'
where continent is not null
group by continent
order by 2 DESC

-- Showing the continent with the highest death count per population
select 
	continent,
	MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%state%'
where continent is not null
group by continent
order by 2 DESC

-- Global numbers 
select 
	--cast(date as datetime) as date,
	sum(new_cases) as total_cases,
	sum(cast(new_deaths as int)) as total_death,
	(sum(cast(new_deaths as int)) / sum(new_cases) )*100 as DeathPercentage
from CovidDeaths
--where location like '%state%'
where continent is not null
	and new_cases is not null
	and new_cases <> 0
--group by date
order by 1,2

-- Looking at total population vs vaccanation
select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population,
	vac.new_vaccinations,
	sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeoplevaccination
from CovidDeaths dea
join CovidVacinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- USE CTE
with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population,
	vac.new_vaccinations,
	sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeoplevaccinated
from CovidDeaths dea
join CovidVacinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select 
	RollingPeopleVaccinated/population * 100
from PopvsVac
where RollingPeopleVaccinated is not null

-- TEMP Table
Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population,
	vac.new_vaccinations,
	sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeoplevaccinated
from CovidDeaths dea
join CovidVacinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select 
	RollingPeoplevaccinated/population * 100
from #PercentPopulationVaccinated
where RollingPeopleVaccinated is not null

select *
from #PercentPopulationVaccinated

-- Creating view to store data for later visualizations
-- Connect teblue to table view
create view PercentPopulationVaccinated as
select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population,
	vac.new_vaccinations,
	sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeoplevaccinated
from CovidDeaths dea
join CovidVacinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select *
from PercentPopulationVaccinated

--











