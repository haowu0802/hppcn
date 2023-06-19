-----------------------------------------------------------
-- NOTES: This file is run on app start after exports are done inside 
-- 		  the engine (once per context created)
-----------------------------------------------------------

-- Find the mod files
-- package.path = package.path .. ";script\\?.lua;script\\country\\?.lua"
-- package.path = package.path .. ";common\\?.lua"
package.path = package.path .. ";tfh\\mod\\HPP\\common\\?.lua"
package.path = package.path .. ";tfh\\mod\\HPP\\script\\?.lua"
package.path = package.path .. ";tfh\\mod\\HPP\\script\\country\\?.lua"

--require('hoi') -- already imported by game, contains all exported classes
require('utils')
require('defines')		-- Don't comment out this line because it will crash the game! It really is required!
require('ai_country')
require('ai_foreign_minister')
require('ai_intelligence_minister')
require('ai_politics_minister')
require('ai_production_minister')
require('ai_support_functions')
require('ai_trade')
require('ai_tech_minister')
require('ai_license')

-- load country specific AI modules.
-- Majors
require('GER')
require('ENG')
require('SOV')
require('USA')
require('ITA')
require('JAP')
require('FRA')

-- Minors (Alphabetized)
require('AST')
require('BEL')
require('CAN')
require('CGX')
require('CHC')
require('CHI')
require('CSX')
require('CXB')
require('CYN')
require('CZE')
require('FIN')
require('HOL')
require('HUN')
require('MAN')
require('MEN')
require('NJG')
require('NZL')
require('NOR')
require('POL')
require('POR')
require('ROM')
require('SAF')
require('SCH')
require('SIA')
require('SIK')
require('SPA')
require('SPR')
require('SWE')
require('VIC')


-- An additional, fictive nation for maintenance purposes
require('GOD')