Select *
From PortofolioProject1..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortofolioProject1..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population 
From PortofolioProject1..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortofolioProject1..CovidDeaths
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid

Select Location, date, population, total_cases,  (total_cases/population)*100 as PercentagePopulationInfected
From PortofolioProject1..CovidDeaths
order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population

Select Location, population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as PercentagePopulationInfected
From PortofolioProject1..CovidDeaths
Group by location, population
order by PercentagePopulationInfected desc

--Showing Countries with Highest Death Count per Population

Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortofolioProject1..CovidDeaths
Where continent is not null
Group by location
order by TotalDeathCount desc

--Let's BREAK THINGS DOWN BY CONTINENT

--Showing the continents with the highest death count per population

Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortofolioProject1..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortofolioProject1..CovidDeaths
Where continent is not null
--Group by date
order by 1,2


-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortofolioProject1..CovidDeaths dea
Join PortofolioProject1..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
	order by 2,3

	-- USE CTE

	With PopVsVac (Continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
	as
	(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortofolioProject1..CovidDeaths dea
Join PortofolioProject1..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
	--order by 2,3
	)
	Select *, (RollingPeopleVaccinated/population)*100
	From PopVsVac

	-- Temp Table

	Drop Table if exists #PercentPopulationVaccinated
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
		Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortofolioProject1..CovidDeaths dea
Join PortofolioProject1..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
	--Where dea.continent is not null
	--order by 2,3

	Select *, (RollingPeopleVaccinated/population)*100
	From #PercentPopulationVaccinated


	--Creating View to store data for later visualizations

	Create view PercentPopulationVaccinated as
		Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortofolioProject1..CovidDeaths dea
Join PortofolioProject1..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
	--order by 2,3

