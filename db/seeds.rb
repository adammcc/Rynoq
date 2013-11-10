
require 'open-uri'
require 'colorize'


##################### Seed Version 2.0########################

sp500_tickers = ["MMM", "ABT", "ABBV", "ANF", "ACE"]
sp500_names = ["3M Company", "Abbott Laboratories", "AbbVie", "Abercrombie & Fitch Company A", "ACE Limited"]
sp500_tickers.take(5).each_with_index do |ticker,index|
	# check if stock exists in db
	if Stock.where(ticker: ticker).to_a.count == 0
		url = "http://www.bloomberg.com/quote/#{ticker}:US"
		doc = Nokogiri::HTML(open(url))
		description = doc.css('.profile').first.children.first.text
		data = YahooFinance::get_historical_quotes(ticker, Date.parse( '2008-01-01' ), Date.today() )
		quotes = data.reverse


		information = {}
		information[:ticker] = ticker
		information[:company_name] = sp500_names[index]
		information[:description] =  description
		information[:quotes] = quotes
		Stock.create(information)
		puts "#{ticker} was added.".green
	else
		puts "#{ticker} already exists and was not added.".red
	end
end
###################### End Seed Version2.0#####################

# data.reverse.each do |day|
# 	goog.price.create(
# 	  date: day[0],
# 	  open: day[1],
# 	  high: day[2],
# 	  low: day[3],
# 	  close: day[4],
# 	  volume: day[5],
# 	  adjusted: day[6])
# end



#************************Yahoo Fianance API******************************
#************************************************************************

#####Historical

# Getting the historical quote data as a raw array.
# The elements of the array are:
#   [0] - Date
#   [1] - Open
#   [2] - High
#   [3] - Low
#   [4] - Close
#   [5] - Volume
#   [6] - Adjusted Close

# $YahooFinance::get_historical_quotes_days( 'YHOO', 30 )

# => [["2013-11-07", "32.99", "33.05", "32.06", "32.11", "16850700", "32.11"],
#  ["2013-11-06", "33.07", "33.30", "32.71", "32.88", "10826400", "32.88"],
#  ["2013-11-05", "33.03", "33.08", "32.55", "32.97", "13471100", "32.97"],
#  ["2013-11-04", "33.20", "33.66", "33.01", "33.19", "15778500", "33.19"],
#  ["2013-11-01", "33.15", "33.35", "33.00", "33.18", "15201400", "33.18"],
#  ["2013-10-31", "32.43", "33.12", "32.28", "32.94", "15274200", "32.94"],
#  ["2013-10-30", "33.33", "33.48", "32.38", "32.57", "14262700", "32.57"],
#  ["2013-10-29", "33.07", "34.00", "32.82", "33.17", "29325200", "33.17"],
#  ["2013-10-28", "32.09", "32.70", "31.70", "32.35", "18325700", "32.35"],
#  ["2013-10-25", "32.31", "32.95", "32.00", "32.25", "22290000", "32.25"],
#  ["2013-10-24", "33.16", "33.31", "32.81", "33.08", "15086700", "33.08"],
#  ["2013-10-23", "33.76", "33.84", "33.02", "33.10", "15931700", "33.10"],
#  ["2013-10-22", "34.24", "34.60", "33.58", "33.94", "17549100", "33.94"],
#  ["2013-10-21", "33.65", "34.35", "33.65", "34.06", "17776700", "34.06"],
#  ["2013-10-18", "33.17", "33.75", "33.11", "33.43", "24622900", "33.43"],
#  ["2013-10-17", "32.88", "33.01", "32.31", "32.74", "25229700", "32.74"],
#  ["2013-10-16", "33.90", "34.11", "32.83", "33.09", "44820000", "33.09"],
#  ["2013-10-15", "34.20", "34.32", "33.06", "33.38", "42773900", "33.38"],
#  ["2013-10-14", "33.80", "34.10", "33.68", "34.00", "17614000", "34.00"],
#  ["2013-10-11", "33.67", "34.37", "33.61", "34.15", "17012300", "34.15"],
#  ["2013-10-10", "33.49", "33.91", "33.33", "33.87", "23448100", "33.87"],
#  ["2013-10-09", "33.07", "33.33", "31.79", "33.01", "33509700", "33.01"]]

#####Standard

# $YahooFinance::get_standard_quotes( quote_symbols )

# => {"GOOD"=>
#   #<YahooFinance::StandardQuote:0x007f856b2a13e8
#    @ask=18.9,
#    @averageDailyVolume=48909,
#    @bid=17.46,
#    @change="+0.01 - +0.05%",
#    @changePercent=0.05,
#    @changePoints=0.01,
#    @date="11/8/2013",
#    @dayHigh=18.89,
#    @dayLow=18.51,
#    @dayRange="18.51 - 18.89",
#    @formathash=
#     {"s"=>["symbol", "val"],
#      "n"=>["name", "val"],
#      "l1"=>["lastTrade", "val.to_f"],
#      "d1"=>["date", "val"],
#      "t1"=>["time", "val"],
#      "c"=>["change", "val"],
#      "c1"=>["changePoints", "val.to_f"],
#      "p2"=>["changePercent", "val.to_f"],
#      "p"=>["previousClose", "val.to_f"],
#      "o"=>["open", "val.to_f"],
#      "h"=>["dayHigh", "val.to_f"],
#      "g"=>["dayLow", "val.to_f"],
#      "v"=>["volume", "val.to_i"],
#      "m"=>["dayRange", "val"],
#      "l"=>["lastTradeWithTime", "val"],
#      "t7"=>["tickerTrend", "convert(val)"],
#      "a2"=>["averageDailyVolume", "val.to_i"],
#      "b"=>["bid", "val.to_f"],
#      "a"=>["ask", "val.to_f"]},
#    @lastTrade=18.83,
#    @lastTradeWithTime="Nov  8 - <b>18.83</b>",
#    @name="Gladstone Commerc",
#    @open=18.89,
#    @previousClose=18.82,
#    @symbol="GOOD",
#    @tickerTrend="&nbsp;==-++-&nbsp;",
#    @time="4:00pm",
#    @volume=41427>}

#####Extended

# $quote_type = YahooFinance::ExtendedQuote
# $YahooFinance::get_quotes( quote_type, "GOOG" )

# => {"GOOG"=>
#   #<YahooFinance::ExtendedQuote:0x007f856b5d9100
#    @annualizedGain="-",
#    @bookValue=248.353,
#    @commission="-",
#    @dayValueChange="- - +0.80%",
#    @dividendPayDate="N/A",
#    @dividendPerShare="0.00",
#    @dividendYield="N/A",
#    @earningsPerShare=36.746,
#    @ebitda="17.599B",
#    @epsEstimateCurrentYear="44.06",
#    @epsEstimateNextQuarter="12.26",
#    @epsEstimateNextYear="52.15",
#    @exDividendDate="N/A",
#    @formathash=
#     {"s"=>["symbol", "val"],
#      "n"=>["name", "val"],
#      "w"=>["weeks52Range", "val"],
#      "j5"=>["weeks52ChangeFromLow", "val.to_f"],
#      "j6"=>["weeks52ChangePercentFromLow", "val"],
#      "k4"=>["weeks52ChangeFromHigh", "val.to_f"],
#      "k5"=>["weeks52ChangePercentFromHigh", "val"],
#      "e"=>["earningsPerShare", "val.to_f"],
#      "r"=>["peRatio", "val.to_f"],
#      "s7"=>["shortRatio", "val"],
#      "r1"=>["dividendPayDate", "val"],
#      "q"=>["exDividendDate", "val"],
#      "d"=>["dividendPerShare", "convert(val)"],
#      "y"=>["dividendYield", "convert(val)"],
#      "j1"=>["marketCap", "convert(val)"],
#      "t8"=>["oneYearTargetPrice", "val"],
#      "e7"=>["epsEstimateCurrentYear", "val"],
#      "e8"=>["epsEstimateNextYear", "val"],
#      "e9"=>["epsEstimateNextQuarter", "val"],
#      "r6"=>["pricePerEPSEstimateCurrentYear", "val"],
#      "r7"=>["pricePerEPSEstimateNextYear", "val"],
#      "r5"=>["pegRatio", "val.to_f"],
#      "b4"=>["bookValue", "val.to_f"],
#      "p6"=>["pricePerBook", "val.to_f"],
#      "p5"=>["pricePerSales", "val.to_f"],
#      "j4"=>["ebitda", "val"],
#      "m3"=>["movingAve50days", "val"],
#      "m7"=>["movingAve50daysChangeFrom", "val"],
#      "m8"=>["movingAve50daysChangePercentFrom", "val"],
#      "m4"=>["movingAve200days", "val"],
#      "m5"=>["movingAve200daysChangeFrom", "val"],
#      "m6"=>["movingAve200daysChangePercentFrom", "val"],
#      "m6"=>["movingAve200daysChangePercentFrom", "val"],
#      "s1"=>["sharesOwned", "val"],
#      "p1"=>["pricePaid", "val"],
#      "c3"=>["commission", "val"],
#      "v1"=>["holdingsValue", "val"],
#      "w1"=>["dayValueChange", "val"],
#      "g1"=>["holdingsGainPercent", "val"],
#      "g4"=>["holdingsGain", "val"],
#      "d2"=>["tradeDate", "val"],
#      "g3"=>["annualizedGain", "val"],
#      "l2"=>["highLimit", "val"],
#      "l3"=>["lowLimit", "val"],
#      "n4"=>["notes", "val"],
#      "x"=>["stockExchange", "val"]},
#    @highLimit="-",
#    @holdingsGain="-",
#    @holdingsGainPercent="- - -",
#    @holdingsValue="-",
#    @lowLimit="-",
#    @marketCap="339.4B",
#    @movingAve200days="893.547",
#    @movingAve200daysChangeFrom="+122.483",
#    @movingAve200daysChangePercentFrom="+13.71%",
#    @movingAve50days="938.275",
#    @movingAve50daysChangeFrom="+77.755",
#    @movingAve50daysChangePercentFrom="+8.29%",
#    @name="Google Inc.",
#    @notes="-",
#    @oneYearTargetPrice="1078.97",
#    @peRatio=27.43,
#    @pegRatio=1.4,
#    @pricePaid="-",
#    @pricePerBook=4.06,
#    @pricePerEPSEstimateCurrentYear="22.88",
#    @pricePerEPSEstimateNextYear="19.33",
#    @pricePerSales=5.87,
#    @sharesOwned="-",
#    @shortRatio="2.90",
#    @stockExchange="NasdaqNM",
#    @symbol="GOOG",
#    @tradeDate="-",
#    @weeks52ChangeFromHigh=-25.49,
#    @weeks52ChangeFromLow=380.03,
#    @weeks52ChangePercentFromHigh="-2.45%",
#    @weeks52ChangePercentFromLow="+59.75%",
#    @weeks52Range="636.00 - 1041.52">}


#********************************* S&P 500 Data************************************
# ["MMM", "ABT", "ABBV", "ANF", "ACE", "ACN", "ACT", "ADBE", "ADT", "AES", "AET", "AFL", "A", "GAS", "APD", "ARG", "AKAM", "AA", "ALXN", "ATI", "AGN", "ALL", "ALTR", "MO", "AMZN", "AEE", "AEP", "AXP", "AIG", "AMT", "AMP", "ABC", "AME", "AMGN", "APH", "APC", "ADI", "AON", "APA", "AIV", "AAPL", "AMAT", "ADM", "AIZ", "T", "ADSK", "ADP", "AN", "AZO", "AVB", "AVY", "AVP", "BHI", "BLL", "BAC", "BK", "BCR", "BAX", "BBT", "BEAM", "BDX", "BBBY", "BMS", "BRK.B", "BBY", "BIIB", "BLK", "HRB", "BA", "BWA", "BXP", "BSX", "BMY", "BRCM", "BF.B", "CHRW", "CA", "CVC", "COG", "CAM", "CPB", "COF", "CAH", "CFN", "KMX", "CCL", "CAT", "CBG", "CBS", "CELG", "CNP", "CTL", "CERN", "CF", "SCHW", "CHK", "CVX", "CMG", "CB", "CI", "CINF", "CTAS", "CSCO", "C", "CTXS", "CLF", "CLX", "CME", "CMS", "COH", "KO", "CCE", "CTSH", "CL", "CMCSA", "CMA", "CSC", "CAG", "COP", "CNX", "ED", "STZ", "GLW", "COST", "COV", "CCI", "CSX", "CMI", "CVS", "DHI", "DHR", "DRI", "DVA", "DE", "DELL", "DLPH", "DAL", "DNR", "XRAY", "DVN", "DO", "DTV", "DFS", "DISCA", "DG", "DLTR", "D", "DOV", "DOW", "DPS", "DTE", "DD", "DUK", "DNB", "ETFC", "EMN", "ETN", "EBAY", "ECL", "EIX", "EW", "EA", "EMC", "EMR", "ESV", "ETR", "EOG", "EQT", "EFX", "EQR", "EL", "EXC", "EXPE", "EXPD", "ESRX", "XOM", "FFIV", "FDO", "FAST", "FDX", "FIS", "FITB", "FSLR", "FE", "FISV", "FLIR", "FLS", "FLR", "FMC", "FTI", "F", "FRX", "FOSL", "BEN", "FCX", "FTR", "GME", "GCI", "GPS", "GRMN", "GD", "GE", "GIS", "GM", "GPC", "GNW", "GILD", "GS", "GT", "GOOG", "GWW", "HAL", "HOG", "HAR", "HRS", "HIG", "HAS", "HCP", "HCN", "HP", "HES", "HPQ", "HD", "HON", "HRL", "HSP", "HST", "HCBK", "HUM", "HBAN", "ITW", "IR", "TEG", "INTC", "ICE", "IBM", "IGT", "IP", "IPG", "IFF", "INTU", "ISRG", "IVZ", "IRM", "JBL", "JEC", "JDSU", "JNJ", "JCI", "JOY", "JPM", "JNPR", "KSU", "K", "KEY", "KMB", "KIM", "KMI", "KLAC", "KSS", "KRFT", "KR", "LTD", "LLL", "LH", "LRCX", "LM", "LEG", "LEN", "LUK", "LIFE", "LLY", "LNC", "LLTC", "LMT", "L", "LO", "LOW", "LSI", "LYB", "MTB", "MAC", "M", "MRO", "MPC", "MAR", "MMC", "MAS", "MA", "MAT", "MKC", "MCD", "MHFI", "MCK", "MJN", "MWV", "MDT", "MRK", "MET", "MCHP", "MU", "MSFT", "MOLX", "TAP", "MDLZ", "MON", "MNST", "MCO", "MS", "MOS", "MSI", "MUR", "MYL", "NBR", "NDAQ", "NOV", "NTAP", "NFLX", "NWL", "NFX", "NEM", "NWSA", "NEE", "NLSN", "NKE", "NI", "NE", "NBL", "JWN", "NSC", "NTRS", "NOC", "NU", "NRG", "NUE", "NVDA", "NYX", "ORLY", "OXY", "OMC", "OKE", "ORCL", "OI", "PCG", "PCAR", "PLL", "PH", "PDCO", "PAYX", "BTU", "JCP", "PNR", "PBCT", "POM", "PEP", "PKI", "PRGO", "PETM", "PFE", "PM", "PSX", "PNW", "PXD", "PBI", "PCL", "PNC", "RL", "PPG", "PPL", "PX", "PCP", "PCLN", "PFG", "PG", "PGR", "PLD", "PRU", "PEG", "PSA", "PHM", "PVH", "QEP", "PWR", "QCOM", "DGX", "RRC", "RTN", "RHT", "REGN", "RF", "RSG", "RAI", "RHI", "ROK", "COL", "ROP", "ROST", "RDC", "R", "SWY", "CRM", "SNDK", "SCG", "SLB", "SNI", "STX", "SEE", "SRE", "SHW", "SIAL", "SPG", "SLM", "SJM", "SNA", "SO", "LUV", "SWN", "SE", "STJ", "SWK", "SPLS", "SBUX", "HOT", "STT", "SRCL", "SYK", "STI", "SYMC", "SYY", "TROW", "TGT", "TEL", "TE", "THC", "TDC", "TER", "TSO", "TXN", "TXT", "HSY", "TRV", "TMO", "TIF", "TWX", "TWC", "TJX", "TMK", "TSS", "TRIP", "FOXA", "TSN", "TYC", "USB", "UNP", "UNH", "UPS", "X", "UTX", "UNM", "URBN", "VFC", "VLO", "VAR", "VTR", "VRSN", "VZ", "VRTX", "VIAB", "V", "VNO", "VMC", "WMT", "WAG", "DIS", "WPO", "WM", "WAT", "WLP", "WFC", "WDC", "WU", "WY", "WHR", "WFM", "WMB", "WIN", "WEC", "WPX", "WYN", "WYNN", "XEL", "XRX", "XLNX", "XL", "XYL", "YHOO", "YUM", "ZMH", "ZION", "ZTS"]
# ["3M Company", "Abbott Laboratories", "AbbVie", "Abercrombie & Fitch Company A", "ACE Limited", "Accenture plc", "Actavis plc", "Adobe Systems Inc", "ADT Corp", "AES Corp", "Aetna Inc", "AFLAC Inc", "Agilent Technologies Inc", "AGL Resources Inc.", "Air Products & Chemicals Inc", "Airgas Inc", "Akamai Technologies Inc", "Alcoa Inc", "Alexion Pharmaceuticals", "Allegheny Technologies Inc", "Allergan Inc", "Allstate Corp", "Altera Corp", "Altria Group Inc", "Amazon.com Inc", "Ameren Corp", "American Electric Power", "American Express Co", "American Intl Group Inc", "American Tower Corp A", "Ameriprise Financial", "AmerisourceBergen Corp", "Ametek", "Amgen Inc", "Amphenol Corp A", "Anadarko Petroleum Corp", "Analog Devices, Inc.", "Aon plc", "Apache Corporation", "Apartment Investment & Mgmt", "Apple Inc.", "Applied Materials Inc", "Archer-Daniels-Midland Co", "Assurant Inc", "AT&T Inc", "Autodesk Inc", "Automatic Data Processing", "AutoNation Inc", "AutoZone Inc", "AvalonBay Communities, Inc.", "Avery Dennison Corp", "Avon Products", "Baker Hughes Inc", "Ball Corp", "Bank of America Corp", "The Bank of New York Mellon Corp.", "Bard (C.R.) Inc.", "Baxter International Inc.", "BB&T Corporation", "Beam Inc.", "Becton Dickinson", "Bed Bath & Beyond", "Bemis Company", "Berkshire Hathaway", "Best Buy Co. Inc.", "BIOGEN IDEC Inc.", "BlackRock", "Block H&R", "Boeing Company", "BorgWarner", "Boston Properties", "Boston Scientific", "Bristol-Myers Squibb", "Broadcom Corporation", "Brown-Forman Corporation", "C. H. Robinson Worldwide", "CA, Inc.", "Cablevision Systems Corp.", "Cabot Oil & Gas", "Cameron International Corp.", "Campbell Soup", "Capital One Financial", "Cardinal Health Inc.", "Carefusion", "Carmax Inc", "Carnival Corp.", "Caterpillar Inc.", "CBRE Group", "CBS Corp.", "Celgene Corp.", "CenterPoint Energy", "CenturyLink Inc", "Cerner", "CF Industries Holdings Inc", "Charles Schwab", "Chesapeake Energy", "Chevron Corp.", "Chipotle Mexican Grill", "Chubb Corp.", "CIGNA Corp.", "Cincinnati Financial", "Cintas Corporation", "Cisco Systems", "Citigroup Inc.", "Citrix Systems", "Cliffs Natural Resources", "The Clorox Company", "CME Group Inc.", "CMS Energy", "Coach Inc.", "The Coca Cola Company", "Coca-Cola Enterprises", "Cognizant Technology Solutions", "Colgate-Palmolive", "Comcast Corp.", "Comerica Inc.", "Computer Sciences Corp.", "ConAgra Foods Inc.", "ConocoPhillips", "CONSOL Energy Inc.", "Consolidated Edison", "Constellation Brands", "Corning Inc.", "Costco Co.", "Covidien plc", "Crown Castle International Corp.", "CSX Corp.", "Cummins Inc.", "CVS Caremark Corp.", "D. R. Horton", "Danaher Corp.", "Darden Restaurants", "DaVita Inc.", "Deere & Co.", "Dell Inc.", "Delphi Automotive", "Delta Air Lines", "Denbury Resources Inc.", "Dentsply International", "Devon Energy Corp.", "Diamond Offshore Drilling", "DirecTV", "Discover Financial Services", "Discovery Communications", "Dollar General", "Dollar Tree", "Dominion Resources", "Dover Corp.", "Dow Chemical", "Dr Pepper Snapple Group", "DTE Energy Co.", "Du Pont (E.I.)", "Duke Energy", "Dun & Bradstreet", "E-Trade", "Eastman Chemical", "Eaton Corp.", "eBay Inc.", "Ecolab Inc.", "Edison Int'l", "Edwards Lifesciences", "Electronic Arts", "EMC Corp.", "Emerson Electric", "Ensco plc", "Entergy Corp.", "EOG Resources", "EQT Corporation", "Equifax Inc.", "Equity Residential", "Estee Lauder Cos.", "Exelon Corp.", "Expedia Inc.", "Expeditors Int'l", "Express Scripts", "Exxon Mobil Corp.", "F5 Networks", "Family Dollar Stores", "Fastenal Co", "FedEx Corporation", "Fidelity National Information Services", "Fifth Third Bancorp", "First Solar Inc", "FirstEnergy Corp", "Fiserv Inc", "FLIR Systems", "Flowserve Corporation", "Fluor Corp.", "FMC Corporation", "FMC Technologies Inc.", "Ford Motor", "Forest Laboratories", "Fossil, Inc.", "Franklin Resources", "Freeport-McMoran Cp & Gld", "Frontier Communications", "GameStop Corp.", "Gannett Co.", "Gap (The)", "Garmin Ltd.", "General Dynamics", "General Electric", "General Mills", "General Motors", "Genuine Parts", "Genworth Financial Inc.", "Gilead Sciences", "Goldman Sachs Group", "Goodyear Tire & Rubber", "Google Inc.", "Grainger (W.W.) Inc.", "Halliburton Co.", "Harley-Davidson", "Harman Int'l Industries", "Harris Corporation", "Hartford Financial Svc.Gp.", "Hasbro Inc.", "HCP Inc.", "Health Care REIT", "Helmerich & Payne", "Hess Corporation", "Hewlett-Packard", "Home Depot", "Honeywell Int'l Inc.", "Hormel Foods Corp.", "Hospira Inc.", "Host Hotels & Resorts", "Hudson City Bancorp", "Humana Inc.", "Huntington Bancshares", "Illinois Tool Works", "Ingersoll-Rand PLC", "Integrys Energy Group Inc.", "Intel Corp.", "IntercontinentalExchange Inc.", "International Bus. Machines", "International Game Technology", "International Paper", "Interpublic Group", "Intl Flavors & Fragrances", "Intuit Inc.", "Intuitive Surgical Inc.", "Invesco Ltd.", "Iron Mountain Incorporated", "Jabil Circuit", "Jacobs Engineering Group", "JDS Uniphase Corp.", "Johnson & Johnson", "Johnson Controls", "Joy Global Inc.", "JPMorgan Chase & Co.", "Juniper Networks", "Kansas City Southern", "Kellogg Co.", "KeyCorp", "Kimberly-Clark", "Kimco Realty", "Kinder Morgan", "KLA-Tencor Corp.", "Kohl's Corp.", "Kraft Foods Group", "Kroger Co.", "L Brands Inc.", "L-3 Communications Holdings", "Laboratory Corp. of America Holding", "Lam Research", "Legg Mason", "Leggett & Platt", "Lennar Corp.", "Leucadia National Corp.", "Life Technologies", "Lilly (Eli) & Co.", "Lincoln National", "Linear Technology Corp.", "Lockheed Martin Corp.", "Loews Corp.", "Lorillard Inc.", "Lowe's Cos.", "LSI Corporation", "LyondellBasell", "M&T Bank Corp.", "Macerich", "Macy's Inc.", "Marathon Oil Corp.", "Marathon Petroleum", "Marriott Int'l.", "Marsh & McLennan", "Masco Corp.", "Mastercard Inc.", "Mattel Inc.", "McCormick & Co.", "McDonald's Corp.", "McGraw Hill Financial", "McKesson Corp.", "Mead Johnson", "MeadWestvaco Corporation", "Medtronic Inc.", "Merck & Co.", "MetLife Inc.", "Microchip Technology", "Micron Technology", "Microsoft Corp.", "Molex Inc.", "Molson Coors Brewing Company", "Mondelez International", "Monsanto Co.", "Monster Beverage", "Moody's Corp", "Morgan Stanley", "The Mosaic Company", "Motorola Solutions Inc.", "Murphy Oil", "Mylan Inc.", "Nabors Industries Ltd.", "NASDAQ OMX Group", "National Oilwell Varco Inc.", "NetApp", "NetFlix Inc.", "Newell Rubbermaid Co.", "Newfield Exploration Co", "Newmont Mining Corp. (Hldg. Co.)", "News Corporation", "NextEra Energy Resources", "Nielsen Holdings", "NIKE Inc.", "NiSource Inc.", "Noble Corp", "Noble Energy Inc", "Nordstrom", "Norfolk Southern Corp.", "Northern Trust Corp.", "Northrop Grumman Corp.", "Northeast Utilities", "NRG Energy", "Nucor Corp.", "Nvidia Corporation", "NYSE Euronext", "O'Reilly Automotive", "Occidental Petroleum", "Omnicom Group", "ONEOK", "Oracle Corp.", "Owens-Illinois Inc", "P G & E Corp.", "PACCAR Inc.", "Pall Corp.", "Parker-Hannifin", "Patterson Companies", "Paychex Inc.", "Peabody Energy", "Penney (J.C.)", "Pentair Ltd.", "People's United Bank", "Pepco Holdings Inc.", "PepsiCo Inc.", "PerkinElmer", "Perrigo", "PetSmart, Inc.", "Pfizer Inc.", "Philip Morris International", "Phillips 66", "Pinnacle West Capital", "Pioneer Natural Resources", "Pitney-Bowes", "Plum Creek Timber Co.", "PNC Financial Services", "Polo Ralph Lauren Corp.", "PPG Industries", "PPL Corp.", "Praxair Inc.", "Precision Castparts", "Priceline.com Inc", "Principal Financial Group", "Procter & Gamble", "Progressive Corp.", "Prologis", "Prudential Financial", "Public Serv. Enterprise Inc.", "Public Storage", "Pulte Homes Inc.", "PVH Corp.", "QEP Resources", "Quanta Services Inc.", "QUALCOMM Inc.", "Quest Diagnostics", "Range Resources Corp.", "Raytheon Co.", "Red Hat Inc.", "Regeneron", "Regions Financial Corp.", "Republic Services Inc", "Reynolds American Inc.", "Robert Half International", "Rockwell Automation Inc.", "Rockwell Collins", "Roper Industries", "Ross Stores", "Rowan Cos.", "Ryder System", "Safeway Inc.", "Salesforce.com", "SanDisk Corporation", "SCANA Corp", "Schlumberger Ltd.", "Scripps Networks Interactive Inc.", "Seagate Technology", "Sealed Air Corp.(New)", "Sempra Energy", "Sherwin-Williams", "Sigma-Aldrich", "Simon Property Group Inc", "SLM Corporation", "Smucker (J.M.)", "Snap-On Inc.", "Southern Co.", "Southwest Airlines", "Southwestern Energy", "Spectra Energy Corp.", "St Jude Medical", "Stanley Black & Decker", "Staples Inc.", "Starbucks Corp.", "Starwood Hotels & Resorts", "State Street Corp.", "Stericycle Inc", "Stryker Corp.", "SunTrust Banks", "Symantec Corp.", "Sysco Corp.", "T. Rowe Price Group", "Target Corp.", "TE Connectivity Ltd.", "TECO Energy", "Tenet Healthcare Corp.", "Teradata Corp.", "Teradyne Inc.", "Tesoro Petroleum Co.", "Texas Instruments", "Textron Inc.", "The Hershey Company", "The Travelers Companies Inc.", "Thermo Fisher Scientific", "Tiffany & Co.", "Time Warner Inc.", "Time Warner Cable Inc.", "TJX Companies Inc.", "Torchmark Corp.", "Total System Services", "TripAdvisor", "Twenty-First Century Fox", "Tyson Foods", "Tyco International", "U.S. Bancorp", "Union Pacific", "United Health Group Inc.", "United Parcel Service", "United States Steel Corp.", "United Technologies", "Unum Group", "Urban Outfitters", "V.F. Corp.", "Valero Energy", "Varian Medical Systems", "Ventas Inc", "Verisign Inc.", "Verizon Communications", "Vertex Pharmaceuticals Inc", "Viacom Inc.", "Visa Inc.", "Vornado Realty Trust", "Vulcan Materials", "Wal-Mart Stores", "Walgreen Co.", "The Walt Disney Company", "Washington Post Co B", "Waste Management Inc.", "Waters Corporation", "WellPoint Inc.", "Wells Fargo", "Western Digital", "Western Union Co", "Weyerhaeuser Corp.", "Whirlpool Corp.", "Whole Foods Market", "Williams Cos.", "Windstream Communications", "Wisconsin Energy Corporation", "WPX Energy, Inc.", "Wyndham Worldwide", "Wynn Resorts Ltd", "Xcel Energy Inc", "Xerox Corp.", "Xilinx Inc", "XL Capital", "Xylem Inc.", "Yahoo Inc.", "Yum! Brands Inc", "Zimmer Holdings", "Zions Bancorp", "Zoetis"]
