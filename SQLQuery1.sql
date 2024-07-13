/*

Queries used for Tableau Project

*/

--1

SELECT SUM(new_cases) AS Total_cases, SUM(CAST(new_deaths AS BIGINT)) AS Total_deaths, SUM(CAST(new_deaths AS BIGINT))/ SUM(new_cases)*100  AS Death_percentage
FROM portfolio_projects..['owid-covid-data$']
--WHERE location = 'india'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2

--2
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From portfolio_projects..['owid-covid-data$']
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



--3
-- Countries with Highest Infection Rate
SELECT location,population, MAX( total_cases) AS Highest_infection_count, MAX(total_cases/population)*100 AS population_infected_percentage
FROM portfolio_projects..['owid-covid-data$']
--WHERE location = 'india'
GROUP BY location, population
ORDER BY population_infected_percentage DESC


--4
-- Countries with Highest Infection Rate along with includes dates
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolio_projects..['owid-covid-data$']
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc





