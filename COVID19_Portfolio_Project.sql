/*** Covid19 Deaths and Vaccinations***/

-- COVID DEATHS

-- Display all the data from the CovidDeaths Data

Select *
From SQLPortfolioProject_1..CovidDeaths
Order By 3,4


--Select *
--From SQLPortfolioProject_1..CovidVaccinations
--Order By 3,4



-- Select the data that will be used in the project

Select location, date, total_cases, new_cases, total_deaths, population
From SQLPortfolioProject_1..CovidDeaths
Order By 1,2       -- order by location and date



-- Compare the total cases with the the total number of deaths

Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From SQLPortfolioProject_1..CovidDeaths
Order By 1,2   



-- Compare the total cases with the the total number of deaths for selected countries
---- Calculate the likelihood of dying if a person contracts Covid19

---- Country: United States
Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From SQLPortfolioProject_1..CovidDeaths
Where location like '%states%'
Order By 1,2 

---- Country: Ghana
Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From SQLPortfolioProject_1..CovidDeaths
Where location like '%ghana%'
Order By 1,2 

---- Country: Austria
Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From SQLPortfolioProject_1..CovidDeaths
Where location like '%austria%'
Order By 1,2 

---- Country: Italy
Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From SQLPortfolioProject_1..CovidDeaths
Where location like '%italy%'
Order By 1,2 

---- Country: England
Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From SQLPortfolioProject_1..CovidDeaths
Where location like 'England'
Order By 1,2 

---- Country: United Kingdom
Select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From SQLPortfolioProject_1..CovidDeaths
Where location like '%united kingdom%'
Order By 1,2 



-- Compare the total cases with the the overall population for selected countries
---- Shows the percentage of the population that has gotten Covid19

---- Country: United States
Select location, date, total_cases, population, (total_cases/population)*100 As PercentPopulationInfected
From SQLPortfolioProject_1..CovidDeaths
Where location like '%states%'
Order By 1,2 

---- Country: Ghana
Select location, date, total_cases, population, (total_cases/population)*100 As PercentPopulationInfected
From SQLPortfolioProject_1..CovidDeaths
Where location like '%ghana%'
Order By 1,2 



-- Identify the countries which have the highest infection rate compared to population

Select location, population, Max(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 As PercentPopulationInfected
From SQLPortfolioProject_1..CovidDeaths
--Where location like '%ghana%'
Group By location, population
Order By PercentPopulationInfected Desc



-- Identify the countries with the highest death count per population

Select location, Max(cast(total_deaths as int)) as TotalDeathCount        -- for accurate results, cast the desired column to integer data type since the column data type is "nvarchar(255)"
From SQLPortfolioProject_1..CovidDeaths
--Where location like '%ghana%'
Group By location
Order By TotalDeathCount Desc

/** The above query's output shows that the data contains data for individual countries as well as data for continents and for the entire world. Upon inspection, 
    it was observed that anytime the continent column is stated as null, the location will contain aggregated information for continents and the world.
	To ensure that only data for individual countries are being considered, include the following line to subsequent queries: "where continent is not null"
**/

Select location, Max(cast(total_deaths as int)) as TotalDeathCount        -- for accurate results, cast the desired column to integer data type since the column data type is "nvarchar(255)"
From SQLPortfolioProject_1..CovidDeaths
Where continent is not null
Group By location
Order By TotalDeathCount Desc


Select location, Max(cast(total_deaths as int)) as TotalDeathCount        -- for accurate results, cast the desired column to integer data type since the column data type is "nvarchar(255)"
From SQLPortfolioProject_1..CovidDeaths
Where continent is null
Group By location
Order By TotalDeathCount Desc



-- Breaking things down by continent
---- This will be useful for obtaining a drill down effect in Tableau

---- Displaying the continents with the highest death count per population

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount        -- for accurate results, cast the desired column to integer data type since the column data type is "nvarchar(255)"
From SQLPortfolioProject_1..CovidDeaths
Where continent is not null
Group By continent
Order By TotalDeathCount Desc



-- Global Numbers

-- Find the total number of new cases recorded globally on each day

Select date, Sum(new_cases)       
From SQLPortfolioProject_1..CovidDeaths
Where continent is not null
Group By date
Order By 1,2 



-- Find the total number of new cases and new deaths recorded globally on each day

Select date, Sum(new_cases), Sum(cast(new_deaths as int))    
From SQLPortfolioProject_1..CovidDeaths
Where continent is not null
Group By date
Order By 1,2 



-- Find the total number of new cases, new deaths and the death percentage recorded globally per day

Select date, Sum(new_cases) as TotalNewCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From SQLPortfolioProject_1..CovidDeaths
Where continent is not null
Group By date
Order By 1,2 



-- Find the total number of new cases, new deaths and the death percentage recorded globally

Select Sum(new_cases) as TotalNewCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From SQLPortfolioProject_1..CovidDeaths
Where continent is not null
--Group By date
Order By 1,2 



-- COVID VACCINATIONS

Select *
From SQLPortfolioProject_1..CovidVaccinations


-- Join the data from the covid deaths and covid vaccinations tables

Select *
From SQLPortfolioProject_1..CovidDeaths dea
Join SQLPortfolioProject_1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- Check out the number of vaccinations carried out per day and the total population

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From SQLPortfolioProject_1..CovidDeaths dea
Join SQLPortfolioProject_1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



-- Calculate the number of vaccinations carried out per day, the total population and the total number of vaccinations carried out per location 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, Sum(Cast(vac.new_vaccinations as int)) OVER (Partition By dea.location)     -- The location is used to stop the count from continuing after entering a new country's data zone
From SQLPortfolioProject_1..CovidDeaths dea
Join SQLPortfolioProject_1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

-- NB: An alternative to "cast" in the above query is "convert". Its usage is as follows: Convert(data_type, column). For e.g., Convert(int, vac.new_vaccinations)



-- Calculate the number of vaccinations carried out per day, the total population and the total number of vaccinations carried out per location 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, Sum(Convert(int, vac.new_vaccinations)) OVER (Partition By dea.location Order 
By dea.location, dea.Date) As RollingNumber_PeopleVaccinated
--, (RollingPeopleVaccinated/population)*100                 -- this does not work because it is not possible to use a column that was just created. Use a CTE or temp table
From SQLPortfolioProject_1..CovidDeaths dea
Join SQLPortfolioProject_1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3



-- Using a Common Table Expression (CTE)

With PopvsVac (continent, location, date, population, new_vaccinations, RollingNumber_PeopleVaccinated)     -- NB: The number of columns here must be equal to that in the the select statement
As
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, Sum(Convert(int, vac.new_vaccinations)) OVER (Partition By dea.location Order 
By dea.location, dea.Date) As RollingNumber_PeopleVaccinated
--, (RollingPeopleVaccinated/population)*100                 -- this does not work because it is not possible to use a column that was just created. Use a CTE or temp table
From SQLPortfolioProject_1..CovidDeaths dea
Join SQLPortfolioProject_1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
-- Order by 2,3
)
Select *, (RollingNumber_PeopleVaccinated/population)*100
From PopvsVac



-- Using a Temp Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingNumber_PeopleVaccinated numeric
)


Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, Sum(Convert(int, vac.new_vaccinations)) OVER (Partition By dea.location Order 
By dea.location, dea.Date) As RollingNumber_PeopleVaccinated
--, (RollingPeopleVaccinated/population)*100                 -- this does not work because it is not possible to use a column that was just created. Use a CTE or temp table
From SQLPortfolioProject_1..CovidDeaths dea
Join SQLPortfolioProject_1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
-- Order by 2,3

Select *, (RollingNumber_PeopleVaccinated/population)*100
From #PercentPopulationVaccinated




-- Create a View to store data for subsequent visualizations

Create View PercentPopulationVaccinatedView As
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, Sum(Convert(int, vac.new_vaccinations)) OVER (Partition By dea.location Order 
By dea.location, dea.Date) As RollingNumber_PeopleVaccinated
--, (RollingPeopleVaccinated/population)*100                 -- this does not work because it is not possible to use a column that was just created. Use a CTE or temp table
From SQLPortfolioProject_1..CovidDeaths dea
Join SQLPortfolioProject_1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3



Select *
From PercentPopulationVaccinatedView



