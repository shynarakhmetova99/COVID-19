/* Creating a new table CovidDeaths */
DROP TABLE IF EXISTS coviddeaths;

CREATE TABLE CovidDeaths (
iso_code VARCHAR(3),
continent VARCHAR(50),
location VARCHAR(50),
date DATE,
population INT,
total_cases INT,
new_cases INT,
new_cases_smoothed FLOAT,
total_deaths INT,
new_deaths INT,
new_deaths_smoothed FLOAT,
total_cases_per_million FLOAT,
new_cases_per_million FLOAT,
new_cases_smoothed_per_million FLOAT,
total_deaths_per_million FLOAT,
new_deaths_per_million FLOAT,
new_deaths_smoothed_per_million FLOAT,
reproduction_rate FLOAT,
icu_patients INT,
icu_patients_per_million FLOAT,
hosp_patients INT,
hosp_patients_per_million FLOAT,
weekly_icu_admissions INT,
weekly_icu_admissions_per_million FLOAT,
weekly_hosp_admissions INT,
weekly_hosp_admissions_per_million FLOAT
);
/* Loading data from the csv file */
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/portfolioproject/coviddeaths.csv' INTO TABLE CovidDeaths
FIELDS TERMINATED BY ';'
IGNORE 1 LINES;

SELECT * FROM CovidDeaths;

/* Creating a new table CovidVaccinations */
DROP TABLE IF EXISTS covidvaccinations;

CREATE TABLE CovidVaccinations (
iso_code VARCHAR(3),
continent VARCHAR(50),
location VARCHAR(50),
date DATE,
new_tests INT,
total_tests_per_thousand FLOAT,
new_tests_per_thousand FLOAT,
new_tests_smoothed INT,
new_tests_smoothed_per_thousand FLOAT,
positive_rate FLOAT,
tests_per_case FLOAT,
tests_units VARCHAR(50),
total_vaccinations INT,
people_vaccinated INT,
people_fully_vaccinated INT,
total_boosters INT,
new_vaccinations INT,
new_vaccinations_smoothed INT,
total_vaccinations_per_hundred FLOAT,
people_vaccinated_per_hundred FLOAT,
people_fully_vaccinated_per_hundred FLOAT,
total_boosters_per_hundred FLOAT,
new_vaccinations_smoothed_per_million INT,
new_people_vaccinated_smoothed INT,
new_people_vaccinated_smoothed_per_hundred FLOAT,
stringency_index FLOAT,
population_density FLOAT,
median_age FLOAT,
aged_65_older FLOAT,
aged_70_older FLOAT,
gdp_per_capita FLOAT,
extreme_poverty FLOAT,
cardiovasc_death_rate FLOAT,
diabetes_prevalence FLOAT,
female_smokers FLOAT,
male_smokers FLOAT,
handwashing_facilities FLOAT,
hospital_beds_per_thousand FLOAT,
life_expectancy FLOAT,
human_development_index FLOAT,
population INT,
excess_mortality_cumulative_absolute FLOAT,
excess_mortality_cumulative FLOAT,
excess_mortality FLOAT,
excess_mortality_cumulative_per_million	FLOAT
);
/* Loading data from the csv file */
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/portfolioproject/covidvaccinations.csv' INTO TABLE CovidVaccinations
FIELDS TERMINATED BY ';'
IGNORE 1 LINES;

SELECT * FROM CovidVaccinations;

/* Total Deaths vs Total Cases
Which shows likelihood of dying from COVID in the specified country/region */
SELECT location, date, total_cases, total_deaths, total_deaths/total_cases*100 AS DeathRate
FROM portfolioproject.coviddeaths
WHERE location='United States';

/* Creating view to store data for later data visualization */
CREATE VIEW USDeathRate AS
SELECT location, date, total_cases, total_deaths, total_deaths/total_cases*100 AS DeathRate
FROM portfolioproject.coviddeaths
WHERE location='United States';

/* Total Cases vs Population 
Which show the percentage of population contracted COVID */
SELECT location, date, total_cases, population, total_cases/population*100 AS InfectionRate
FROM portfolioproject.coviddeaths
WHERE location='United States';

/* Creating view to store data for later data visualization */
CREATE VIEW USInfectionRate AS
SELECT location, date, total_cases, population, total_cases/population*100 AS InfectionRate
FROM portfolioproject.coviddeaths
WHERE location='United States';

/* Countries ranked according to their highest infection rates */
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)*100) AS HighestInfectionRate
FROM portfolioproject.coviddeaths
WHERE continent<>''
GROUP BY location, population
ORDER BY HighestInfectionRate DESC;

/* Creating view to store data for later data visualization */
CREATE VIEW InfectionRateRanking AS
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)*100) AS HighestInfectionRate
FROM portfolioproject.coviddeaths
WHERE continent<>''
GROUP BY location, population
ORDER BY HighestInfectionRate DESC;

/* Countries ranked according to total deaths */
SELECT location, population, MAX(total_deaths) as TotalDeaths
FROM portfolioproject.coviddeaths
WHERE continent<>''
GROUP BY location, population
ORDER BY TotalDeaths DESC;

/* Creating view to store data for later data visualization */
CREATE VIEW TotalDeathsRanking AS
SELECT location, population, MAX(total_deaths) as TotalDeaths
FROM portfolioproject.coviddeaths
WHERE continent<>''
GROUP BY location, population
ORDER BY TotalDeaths DESC;

/* Continents ranked according to total deaths */
SELECT location, population, MAX(total_deaths) as TotalDeaths
FROM portfolioproject.coviddeaths
WHERE continent=''
AND location NOT IN ('European Union', 'World','High Income', 'Upper middle income', 'Lower middle income', 'Lower income', 'Low income')
GROUP BY location,population
ORDER BY TotalDeaths DESC;

/* Creating view to store data for later data visualization */
CREATE VIEW TotalDeathsRankingContinents AS
SELECT location, population, MAX(total_deaths) as TotalDeaths
FROM portfolioproject.coviddeaths
WHERE continent=''
AND location NOT IN ('European Union', 'World','High Income', 'Upper middle income', 'Lower middle income', 'Lower income', 'Low income')
GROUP BY location,population
ORDER BY TotalDeaths DESC;

/* Continents ranked according to death count per population */
SELECT location, population, MAX(total_deaths) AS TotalDeaths, MAX(total_deaths/population*100) AS DeathPopPercentage
FROM portfolioproject.coviddeaths
WHERE continent=''
AND location NOT IN ('European Union', 'World','High Income', 'Upper middle income', 'Lower middle income', 'Lower income', 'Low income')
GROUP BY location,population
ORDER BY DeathPopPercentage DESC;

/* Creating view to store data for later data visualization */
CREATE VIEW TotalDeathsPercentageContinents AS
SELECT location, population, MAX(total_deaths) AS TotalDeaths, MAX(total_deaths/population*100) AS DeathPopPercentage
FROM portfolioproject.coviddeaths
WHERE continent=''
AND location NOT IN ('European Union', 'World','High Income', 'Upper middle income', 'Lower middle income', 'Lower income', 'Low income')
GROUP BY location,population
ORDER BY DeathPopPercentage DESC;

/* Global death rate */
SELECT date, total_cases, total_deaths, total_deaths/total_cases*100 AS DeathRate
FROM portfolioproject.coviddeaths
WHERE location='World';

/* Creating view to store data for later data visualization */
CREATE VIEW WorldDeathRate AS
SELECT date, total_cases, total_deaths, total_deaths/total_cases*100 AS DeathRate
FROM portfolioproject.coviddeaths
WHERE location='World';

/* Countries ranked according to vaccination rate */
SELECT va.continent, va.location, de.population, MAX(va.people_fully_vaccinated) as PeopleFullyVaccinated,
MAX(va.people_fully_vaccinated)/de.population*100 AS VaccinationRate
FROM portfolioproject.coviddeaths de
INNER JOIN portfolioproject.covidvaccinations va
ON de.location=va.location
AND de.date=va.date
WHERE va.continent<>''
GROUP BY va.continent,va.location,de.population
ORDER BY VaccinationRate DESC;

/* Creating view to store data for later data visualization */
CREATE VIEW VaccinationRateRanking AS
SELECT va.continent, va.location, de.population, MAX(va.people_fully_vaccinated) as PeopleFullyVaccinated,
MAX(va.people_fully_vaccinated)/de.population*100 AS VaccinationRate
FROM portfolioproject.coviddeaths de
INNER JOIN portfolioproject.covidvaccinations va
ON de.location=va.location
AND de.date=va.date
WHERE va.continent<>''
GROUP BY va.continent,va.location,de.population
ORDER BY VaccinationRate DESC;

/* Vaccination rate progress in the US */
-- Using CTE
WITH PopvsVac AS
(
SELECT de.location, de.date, de.population, va.new_people_vaccinated_smoothed,
SUM(va.new_people_vaccinated_smoothed) OVER (PARTITION BY de.location ORDER BY de.location, de.date) AS TotalPeopleVaccinated
FROM portfolioproject.coviddeaths de
INNER JOIN portfolioproject.covidvaccinations va
ON de.location=va.location AND de.date=va.date
WHERE de.location='United States'
)

SELECT *, TotalPeopleVaccinated/population*100 AS VaccinationRate FROM PopvsVac;

-- Using Temp Table
DROP TEMPORARY TABLE IF EXISTS PopvsVacTab;

CREATE TEMPORARY TABLE PopvsVacTab
(
Location VARCHAR(50),
Date datetime,
Population INT,
NewPeopleVaccinated INT,
TotalPeopleVaccinated INT
);

INSERT INTO PopvsVacTab
SELECT de.location, de.date, de.population, va.new_people_vaccinated_smoothed,
SUM(va.new_people_vaccinated_smoothed) OVER (PARTITION BY de.location ORDER BY de.location, de.date) AS TotalPeopleVaccinated
FROM portfolioproject.coviddeaths de
INNER JOIN portfolioproject.covidvaccinations va
ON de.location=va.location AND de.date=va.date
WHERE de.location='United States';

SELECT *, TotalPeopleVaccinated/Population*100 AS VaccinationRate
FROM PopvsVacTab;

/* Creating view to store data for later data visualization */
CREATE VIEW USVaccinationRateView AS
SELECT de.location, de.date, de.population, va.new_people_vaccinated_smoothed,
SUM(va.new_people_vaccinated_smoothed) OVER (PARTITION BY de.location ORDER BY de.location, de.date) AS TotalPeopleVaccinated
FROM portfolioproject.coviddeaths de
INNER JOIN portfolioproject.covidvaccinations va
ON de.location=va.location AND de.date=va.date
WHERE de.location='United States';

/* Several coutnries' Infection Rate Data Series */
SELECT location, date, population, total_cases, total_cases / population * 100 AS InfectionRate
FROM portfolioproject.coviddeaths
WHERE location = 'Brazil';

SELECT location, date, population, total_cases, total_cases / population * 100 AS InfectionRate
FROM portfolioproject.coviddeaths
WHERE location = 'India';

SELECT location, date, population, total_cases, total_cases / population * 100 AS InfectionRate
FROM portfolioproject.coviddeaths
WHERE location = 'China';

SELECT location, date, population, total_cases, total_cases / population * 100 AS InfectionRate
FROM portfolioproject.coviddeaths
WHERE location = 'Kazakhstan';
