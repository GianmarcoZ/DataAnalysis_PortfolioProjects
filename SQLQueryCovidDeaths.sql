--Clean Population Data
SELECT TRIM(population) FROM CovidDeaths

 --Average of cases number in Austria and Switzerland in a time range
SELECT date, location, population, total_cases, AVG(total_cases) OVER (PARTITION BY 1) FROM CovidDeaths
WHERE location = 'Switzerland' OR location = 'Austria' 
AND date BETWEEN '2021-03-01' AND '2023-03-01'
ORDER BY date DESC


--View Data Types of columns
select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.columns
WHERE TABLE_NAME = 'CovidDeaths'

 --Adjust table Data Types to support decimal numbers
ALTER TABLE PortfolioProject.dbo.CovidDeaths
ALTER COLUMN total_deaths float;
ALTER TABLE PortfolioProject.dbo.CovidDeaths
ALTER COLUMN total_cases float
ALTER TABLE PortfolioProject.dbo.CovidDeaths
ALTER COLUMN new_cases float
ALTER TABLE PortfolioProject.dbo.CovidDeaths
ALTER COLUMN new_deaths float
ALTER TABLE PortfolioProject.dbo.CovidVaccinations
ALTER COLUMN new_vaccinations float

--probabilità di morte se si contrae il covid:
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1,2

--casi totali vs popolazione
SELECT location, date, total_cases, population, (total_cases/population)*100 AS PercentageOfCases 
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Italy'

--quale paese ha il tasso di infezione più alto?
SELECT location, population, MAX(total_cases) AS HighestInfectionCount
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY location, population
ORDER BY HighestInfectionCount DESC
 
SELECT * FROM CovidDeaths
--countries with the highest death count per population
SELECT location, MAX(total_deaths) AS TotalDeathsCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent iS NOT NULL
GROUP BY location
ORDER BY TotalDeathsCount DESC

--continents with the highest death count per population
SELECT continent, MAX(total_deaths) AS TotalDeathsCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent iS NOT NULL
GROUP BY continent
ORDER BY TotalDeathsCount DESC

--Global numbers
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not NULL
ORDER BY 1,2

SELECT SUM(new_cases) as TotalNewCases, SUM(new_deaths) AS TotalNewDeaths, 
SUM(new_deaths)/SUM(new_cases)*100 as NewDeathsIncidency
FROM CovidDeaths
WHERE new_cases is not null and new_cases <> 0


--Total world population VS Vaccination 
SELECT Deaths.continent, Deaths.location, Deaths.date, Vacc.new_vaccinations, 
SUM(Vacc.new_vaccinations) OVER (PARTITION BY Deaths.location ORDER BY Deaths.location, Deaths.date) AS NewVaccinesIncrement
FROM PortfolioProject.dbo.CovidDeaths AS Deaths
JOIN PortfolioProject.dbo.CovidVaccinations AS Vacc
ON Deaths.location = Vacc.location
AND Deaths.date = Vacc.date
WHERE Deaths.continent IS NOT NULL
ORDER BY 2,3

