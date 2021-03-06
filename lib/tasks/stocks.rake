namespace :stocks do

  desc "Get the most recent quotes for all stocks"
  task :update, [:stock_num] => :environment do |t, args|
  	Rails.logger.info("**********************************")
  	Rails.logger.info("#{Time.now} - Update rake was run.")
  	stock_num = args.stock_num || Stock.count
  	# make the last day yesterday because Yahoo historical data is 1 day old
  	today = Date.today.prev_day
  	# exclude the weekend
  	while today.saturday? || today.sunday?
  		today = today.prev_day
  	end
  	# if stock market is still open move the date to the previous day
  	# also we giving yahoo an hour to get their shit together
  	# today = today.prev_day if Time.now.hour < 17

  	stocks_to_update = []
  	# check wich stock have quotes that need to be updated
  	Stock.all.each do |stock|
  		last_quote = Date.parse(stock.quotes.last[0])
  		if today > last_quote
  			stocks_to_update << [stock.ticker,last_quote.to_s]
  		else
  			puts "#{stock.ticker} is upto date".yellow
  		end
  	end

  	stocks_to_update.take(stock_num.to_i).each do |stock|
  		data = YahooFinance::get_historical_quotes( stock.first, 
  																				Date.parse( stock.last ).next,
                                      		Date.today )
  		if !data.empty?
	  		quotes = data.reverse
	  		# find a stock to which needs to be updated and add new quotes
	  		@stock = Stock.find(stock.first)
	  		@stock.quotes.concat(quotes)
	  		@stock.save
	  		puts "#{stock.first} was successfully updated!".green
	  	else
	  		puts "No new data for #{stock.first} on YahooFinance, try after 4 PM".yellow
	  	end
  	end
  end

  # desc "Daily stock update"

  desc "populate database with a number(argument) of actual S&P500 stocks witch quotes since 2000-01-01"
  task :mass_add, [:stock_num] => [:environment] do |t, args|
  	# s&p500 tickers and company names
  	sp500_tickers = ["MMM", "ABT", "ABBV", "ANF", "ACE", "ACN", "ACT", "ADBE", "ADT", "AES", "AET", "AFL", "A", "GAS", "APD", "ARG", "AKAM", "AA", "ALXN", "ATI", "AGN", "ALL", "ALTR", "MO", "AMZN", "AEE", "AEP", "AXP", "AIG", "AMT", "AMP", "ABC", "AME", "AMGN", "APH", "APC", "ADI", "AON", "APA", "AIV", "AAPL", "AMAT", "ADM", "AIZ", "T", "ADSK", "ADP", "AN", "AZO", "AVB", "AVY", "AVP", "BHI", "BLL", "BAC", "BK", "BCR", "BAX", "BBT", "BEAM", "BDX", "BBBY", "BMS", "BRK-B", "BBY", "BIIB", "BLK", "HRB", "BA", "BWA", "BXP", "BSX", "BMY", "BRCM", "BF.B", "CHRW", "CA", "CVC", "COG", "CAM", "CPB", "COF", "CAH", "CFN", "KMX", "CCL", "CAT", "CBG", "CBS", "CELG", "CNP", "CTL", "CERN", "CF", "SCHW", "CHK", "CVX", "CMG", "CB", "CI", "CINF", "CTAS", "CSCO", "C", "CTXS", "CLF", "CLX", "CME", "CMS", "COH", "KO", "CCE", "CTSH", "CL", "CMCSA", "CMA", "CSC", "CAG", "COP", "CNX", "ED", "STZ", "GLW", "COST", "COV", "CCI", "CSX", "CMI", "CVS", "DHI", "DHR", "DRI", "DVA", "DE", "DLPH", "DAL", "DNR", "XRAY", "DVN", "DO", "DTV", "DFS", "DISCA", "DG", "DLTR", "D", "DOV", "DOW", "DPS", "DTE", "DD", "DUK", "DNB", "ETFC", "EMN", "ETN", "EBAY", "ECL", "EIX", "EW", "EA", "EMC", "EMR", "ESV", "ETR", "EOG", "EQT", "EFX", "EQR", "EL", "EXC", "EXPE", "EXPD", "ESRX", "XOM", "FFIV", "FDO", "FAST", "FDX", "FIS", "FITB", "FSLR", "FE", "FISV", "FLIR", "FLS", "FLR", "FMC", "FTI", "F", "FRX", "FOSL", "BEN", "FCX", "FTR", "GME", "GCI", "GPS", "GRMN", "GD", "GE", "GIS", "GM", "GPC", "GNW", "GILD", "GS", "GT", "GOOG", "GWW", "HAL", "HOG", "HAR", "HRS", "HIG", "HAS", "HCP", "HCN", "HP", "HES", "HPQ", "HD", "HON", "HRL", "HSP", "HST", "HCBK", "HUM", "HBAN", "ITW", "IR", "TEG", "INTC", "ICE", "IBM", "IGT", "IP", "IPG", "IFF", "INTU", "ISRG", "IVZ", "IRM", "JBL", "JEC", "JDSU", "JNJ", "JCI", "JOY", "JPM", "JNPR", "KSU", "K", "KEY", "KMB", "KIM", "KMI", "KLAC", "KSS", "KRFT", "KR", "LTD", "LLL", "LH", "LRCX", "LM", "LEG", "LEN", "LUK", "LIFE", "LLY", "LNC", "LLTC", "LMT", "L", "LO", "LOW", "LSI", "LYB", "MTB", "MAC", "M", "MRO", "MPC", "MAR", "MMC", "MAS", "MA", "MAT", "MKC", "MCD", "MHFI", "MCK", "MJN", "MWV", "MDT", "MRK", "MET", "MCHP", "MU", "MSFT", "MOLX", "TAP", "MDLZ", "MON", "MNST", "MCO", "MS", "MOS", "MSI", "MUR", "MYL", "NBR", "NDAQ", "NOV", "NTAP", "NFLX", "NWL", "NFX", "NEM", "NWSA", "NEE", "NLSN", "NKE", "NI", "NE", "NBL", "JWN", "NSC", "NTRS", "NOC", "NU", "NRG", "NUE", "NVDA", "NYX", "ORLY", "OXY", "OMC", "OKE", "ORCL", "OI", "PCG", "PCAR", "PLL", "PH", "PDCO", "PAYX", "BTU", "JCP", "PNR", "PBCT", "POM", "PEP", "PKI", "PRGO", "PETM", "PFE", "PM", "PSX", "PNW", "PXD", "PBI", "PCL", "PNC", "RL", "PPG", "PPL", "PX", "PCP", "PCLN", "PFG", "PG", "PGR", "PLD", "PRU", "PEG", "PSA", "PHM", "PVH", "QEP", "PWR", "QCOM", "DGX", "RRC", "RTN", "RHT", "REGN", "RF", "RSG", "RAI", "RHI", "ROK", "COL", "ROP", "ROST", "RDC", "R", "SWY", "CRM", "SNDK", "SCG", "SLB", "SNI", "STX", "SEE", "SRE", "SHW", "SIAL", "SPG", "SLM", "SJM", "SNA", "SO", "LUV", "SWN", "SE", "STJ", "SWK", "SPLS", "SBUX", "HOT", "STT", "SRCL", "SYK", "STI", "SYMC", "SYY", "TROW", "TGT", "TEL", "TE", "THC", "TDC", "TER", "TSO", "TXN", "TXT", "HSY", "TRV", "TMO", "TIF", "TWX", "TWC", "TJX", "TMK", "TSS", "TRIP", "FOXA", "TSN", "TYC", "USB", "UNP", "UNH", "UPS", "X", "UTX", "UNM", "URBN", "VFC", "VLO", "VAR", "VTR", "VRSN", "VZ", "VRTX", "VIAB", "V", "VNO", "VMC", "WMT", "WAG", "DIS", "WPO", "WM", "WAT", "WLP", "WFC", "WDC", "WU", "WY", "WHR", "WFM", "WMB", "WIN", "WEC", "WPX", "WYN", "WYNN", "XEL", "XRX", "XLNX", "XL", "XYL", "YHOO", "YUM", "ZMH", "ZION", "ZTS"]
		sp500_names = ["3M Company", "Abbott Laboratories", "AbbVie", "Abercrombie & Fitch Company A", "ACE Limited", "Accenture plc", "Actavis plc", "Adobe Systems Inc", "ADT Corp", "AES Corp", "Aetna Inc", "AFLAC Inc", "Agilent Technologies Inc", "AGL Resources Inc.", "Air Products & Chemicals Inc", "Airgas Inc", "Akamai Technologies Inc", "Alcoa Inc", "Alexion Pharmaceuticals", "Allegheny Technologies Inc", "Allergan Inc", "Allstate Corp", "Altera Corp", "Altria Group Inc", "Amazon.com Inc", "Ameren Corp", "American Electric Power", "American Express Co", "American Intl Group Inc", "American Tower Corp A", "Ameriprise Financial", "AmerisourceBergen Corp", "Ametek", "Amgen Inc", "Amphenol Corp A", "Anadarko Petroleum Corp", "Analog Devices, Inc.", "Aon plc", "Apache Corporation", "Apartment Investment & Mgmt", "Apple Inc.", "Applied Materials Inc", "Archer-Daniels-Midland Co", "Assurant Inc", "AT&T Inc", "Autodesk Inc", "Automatic Data Processing", "AutoNation Inc", "AutoZone Inc", "AvalonBay Communities, Inc.", "Avery Dennison Corp", "Avon Products", "Baker Hughes Inc", "Ball Corp", "Bank of America Corp", "The Bank of New York Mellon Corp.", "Bard (C.R.) Inc.", "Baxter International Inc.", "BB&T Corporation", "Beam Inc.", "Becton Dickinson", "Bed Bath & Beyond", "Bemis Company", "Berkshire Hathaway", "Best Buy Co. Inc.", "BIOGEN IDEC Inc.", "BlackRock", "Block H&R", "Boeing Company", "BorgWarner", "Boston Properties", "Boston Scientific", "Bristol-Myers Squibb", "Broadcom Corporation", "Brown-Forman Corporation", "C. H. Robinson Worldwide", "CA, Inc.", "Cablevision Systems Corp.", "Cabot Oil & Gas", "Cameron International Corp.", "Campbell Soup", "Capital One Financial", "Cardinal Health Inc.", "Carefusion", "Carmax Inc", "Carnival Corp.", "Caterpillar Inc.", "CBRE Group", "CBS Corp.", "Celgene Corp.", "CenterPoint Energy", "CenturyLink Inc", "Cerner", "CF Industries Holdings Inc", "Charles Schwab", "Chesapeake Energy", "Chevron Corp.", "Chipotle Mexican Grill", "Chubb Corp.", "CIGNA Corp.", "Cincinnati Financial", "Cintas Corporation", "Cisco Systems", "Citigroup Inc.", "Citrix Systems", "Cliffs Natural Resources", "The Clorox Company", "CME Group Inc.", "CMS Energy", "Coach Inc.", "The Coca Cola Company", "Coca-Cola Enterprises", "Cognizant Technology Solutions", "Colgate-Palmolive", "Comcast Corp.", "Comerica Inc.", "Computer Sciences Corp.", "ConAgra Foods Inc.", "ConocoPhillips", "CONSOL Energy Inc.", "Consolidated Edison", "Constellation Brands", "Corning Inc.", "Costco Co.", "Covidien plc", "Crown Castle International Corp.", "CSX Corp.", "Cummins Inc.", "CVS Caremark Corp.", "D. R. Horton", "Danaher Corp.", "Darden Restaurants", "DaVita Inc.", "Deere & Co.", "Delphi Automotive", "Delta Air Lines", "Denbury Resources Inc.", "Dentsply International", "Devon Energy Corp.", "Diamond Offshore Drilling", "DirecTV", "Discover Financial Services", "Discovery Communications", "Dollar General", "Dollar Tree", "Dominion Resources", "Dover Corp.", "Dow Chemical", "Dr Pepper Snapple Group", "DTE Energy Co.", "Du Pont (E.I.)", "Duke Energy", "Dun & Bradstreet", "E-Trade", "Eastman Chemical", "Eaton Corp.", "eBay Inc.", "Ecolab Inc.", "Edison Int'l", "Edwards Lifesciences", "Electronic Arts", "EMC Corp.", "Emerson Electric", "Ensco plc", "Entergy Corp.", "EOG Resources", "EQT Corporation", "Equifax Inc.", "Equity Residential", "Estee Lauder Cos.", "Exelon Corp.", "Expedia Inc.", "Expeditors Int'l", "Express Scripts", "Exxon Mobil Corp.", "F5 Networks", "Family Dollar Stores", "Fastenal Co", "FedEx Corporation", "Fidelity National Information Services", "Fifth Third Bancorp", "First Solar Inc", "FirstEnergy Corp", "Fiserv Inc", "FLIR Systems", "Flowserve Corporation", "Fluor Corp.", "FMC Corporation", "FMC Technologies Inc.", "Ford Motor", "Forest Laboratories", "Fossil, Inc.", "Franklin Resources", "Freeport-McMoran Cp & Gld", "Frontier Communications", "GameStop Corp.", "Gannett Co.", "Gap (The)", "Garmin Ltd.", "General Dynamics", "General Electric", "General Mills", "General Motors", "Genuine Parts", "Genworth Financial Inc.", "Gilead Sciences", "Goldman Sachs Group", "Goodyear Tire & Rubber", "Google Inc.", "Grainger (W.W.) Inc.", "Halliburton Co.", "Harley-Davidson", "Harman Int'l Industries", "Harris Corporation", "Hartford Financial Svc.Gp.", "Hasbro Inc.", "HCP Inc.", "Health Care REIT", "Helmerich & Payne", "Hess Corporation", "Hewlett-Packard", "Home Depot", "Honeywell Int'l Inc.", "Hormel Foods Corp.", "Hospira Inc.", "Host Hotels & Resorts", "Hudson City Bancorp", "Humana Inc.", "Huntington Bancshares", "Illinois Tool Works", "Ingersoll-Rand PLC", "Integrys Energy Group Inc.", "Intel Corp.", "IntercontinentalExchange Inc.", "International Bus. Machines", "International Game Technology", "International Paper", "Interpublic Group", "Intl Flavors & Fragrances", "Intuit Inc.", "Intuitive Surgical Inc.", "Invesco Ltd.", "Iron Mountain Incorporated", "Jabil Circuit", "Jacobs Engineering Group", "JDS Uniphase Corp.", "Johnson & Johnson", "Johnson Controls", "Joy Global Inc.", "JPMorgan Chase & Co.", "Juniper Networks", "Kansas City Southern", "Kellogg Co.", "KeyCorp", "Kimberly-Clark", "Kimco Realty", "Kinder Morgan", "KLA-Tencor Corp.", "Kohl's Corp.", "Kraft Foods Group", "Kroger Co.", "L Brands Inc.", "L-3 Communications Holdings", "Laboratory Corp. of America Holding", "Lam Research", "Legg Mason", "Leggett & Platt", "Lennar Corp.", "Leucadia National Corp.", "Life Technologies", "Lilly (Eli) & Co.", "Lincoln National", "Linear Technology Corp.", "Lockheed Martin Corp.", "Loews Corp.", "Lorillard Inc.", "Lowe's Cos.", "LSI Corporation", "LyondellBasell", "M&T Bank Corp.", "Macerich", "Macy's Inc.", "Marathon Oil Corp.", "Marathon Petroleum", "Marriott Int'l.", "Marsh & McLennan", "Masco Corp.", "Mastercard Inc.", "Mattel Inc.", "McCormick & Co.", "McDonald's Corp.", "McGraw Hill Financial", "McKesson Corp.", "Mead Johnson", "MeadWestvaco Corporation", "Medtronic Inc.", "Merck & Co.", "MetLife Inc.", "Microchip Technology", "Micron Technology", "Microsoft Corp.", "Molex Inc.", "Molson Coors Brewing Company", "Mondelez International", "Monsanto Co.", "Monster Beverage", "Moody's Corp", "Morgan Stanley", "The Mosaic Company", "Motorola Solutions Inc.", "Murphy Oil", "Mylan Inc.", "Nabors Industries Ltd.", "NASDAQ OMX Group", "National Oilwell Varco Inc.", "NetApp", "NetFlix Inc.", "Newell Rubbermaid Co.", "Newfield Exploration Co", "Newmont Mining Corp. (Hldg. Co.)", "News Corporation", "NextEra Energy Resources", "Nielsen Holdings", "NIKE Inc.", "NiSource Inc.", "Noble Corp", "Noble Energy Inc", "Nordstrom", "Norfolk Southern Corp.", "Northern Trust Corp.", "Northrop Grumman Corp.", "Northeast Utilities", "NRG Energy", "Nucor Corp.", "Nvidia Corporation", "NYSE Euronext", "O'Reilly Automotive", "Occidental Petroleum", "Omnicom Group", "ONEOK", "Oracle Corp.", "Owens-Illinois Inc", "P G & E Corp.", "PACCAR Inc.", "Pall Corp.", "Parker-Hannifin", "Patterson Companies", "Paychex Inc.", "Peabody Energy", "Penney (J.C.)", "Pentair Ltd.", "People's United Bank", "Pepco Holdings Inc.", "PepsiCo Inc.", "PerkinElmer", "Perrigo", "PetSmart, Inc.", "Pfizer Inc.", "Philip Morris International", "Phillips 66", "Pinnacle West Capital", "Pioneer Natural Resources", "Pitney-Bowes", "Plum Creek Timber Co.", "PNC Financial Services", "Polo Ralph Lauren Corp.", "PPG Industries", "PPL Corp.", "Praxair Inc.", "Precision Castparts", "Priceline.com Inc", "Principal Financial Group", "Procter & Gamble", "Progressive Corp.", "Prologis", "Prudential Financial", "Public Serv. Enterprise Inc.", "Public Storage", "Pulte Homes Inc.", "PVH Corp.", "QEP Resources", "Quanta Services Inc.", "QUALCOMM Inc.", "Quest Diagnostics", "Range Resources Corp.", "Raytheon Co.", "Red Hat Inc.", "Regeneron", "Regions Financial Corp.", "Republic Services Inc", "Reynolds American Inc.", "Robert Half International", "Rockwell Automation Inc.", "Rockwell Collins", "Roper Industries", "Ross Stores", "Rowan Cos.", "Ryder System", "Safeway Inc.", "Salesforce.com", "SanDisk Corporation", "SCANA Corp", "Schlumberger Ltd.", "Scripps Networks Interactive Inc.", "Seagate Technology", "Sealed Air Corp.(New)", "Sempra Energy", "Sherwin-Williams", "Sigma-Aldrich", "Simon Property Group Inc", "SLM Corporation", "Smucker (J.M.)", "Snap-On Inc.", "Southern Co.", "Southwest Airlines", "Southwestern Energy", "Spectra Energy Corp.", "St Jude Medical", "Stanley Black & Decker", "Staples Inc.", "Starbucks Corp.", "Starwood Hotels & Resorts", "State Street Corp.", "Stericycle Inc", "Stryker Corp.", "SunTrust Banks", "Symantec Corp.", "Sysco Corp.", "T. Rowe Price Group", "Target Corp.", "TE Connectivity Ltd.", "TECO Energy", "Tenet Healthcare Corp.", "Teradata Corp.", "Teradyne Inc.", "Tesoro Petroleum Co.", "Texas Instruments", "Textron Inc.", "The Hershey Company", "The Travelers Companies Inc.", "Thermo Fisher Scientific", "Tiffany & Co.", "Time Warner Inc.", "Time Warner Cable Inc.", "TJX Companies Inc.", "Torchmark Corp.", "Total System Services", "TripAdvisor", "Twenty-First Century Fox", "Tyson Foods", "Tyco International", "U.S. Bancorp", "Union Pacific", "United Health Group Inc.", "United Parcel Service", "United States Steel Corp.", "United Technologies", "Unum Group", "Urban Outfitters", "V.F. Corp.", "Valero Energy", "Varian Medical Systems", "Ventas Inc", "Verisign Inc.", "Verizon Communications", "Vertex Pharmaceuticals Inc", "Viacom Inc.", "Visa Inc.", "Vornado Realty Trust", "Vulcan Materials", "Wal-Mart Stores", "Walgreen Co.", "The Walt Disney Company", "Washington Post Co B", "Waste Management Inc.", "Waters Corporation", "WellPoint Inc.", "Wells Fargo", "Western Digital", "Western Union Co", "Weyerhaeuser Corp.", "Whirlpool Corp.", "Whole Foods Market", "Williams Cos.", "Windstream Communications", "Wisconsin Energy Corporation", "WPX Energy, Inc.", "Wyndham Worldwide", "Wynn Resorts Ltd", "Xcel Energy Inc", "Xerox Corp.", "Xilinx Inc", "XL Capital", "Xylem Inc.", "Yahoo Inc.", "Yum! Brands Inc", "Zimmer Holdings", "Zions Bancorp", "Zoetis"]
		 
		sp500_tickers.take(args.stock_num.to_i).each_with_index do |ticker,index|
			
			# check if stock exists in db
			if Stock.where(ticker: ticker).to_a.count == 0
				data = YahooFinance::get_historical_quotes(ticker, Date.parse( '2000-01-01' ), Date.today() )
				# check if ticker was found on Yahoo Finance
				if !data.empty?
					# chronologize the order
					quotes = data.reverse
					url = "http://www.bloomberg.com/quote/#{ticker}:US"
					require 'open-uri'
					doc = Nokogiri::HTML(open(url))
					begin
						description = doc.css(".profile").text
					rescue => exception
						puts exception.message.red
						description = "#{sp500_names[index]} is a publicly traded S&P500 company."
					end

					attributes = {}
					attributes[:ticker] = ticker
					attributes[:company_name] = sp500_names[index]
					attributes[:description] =  description
					attributes[:quotes] = quotes
					Stock.create(attributes)
					puts "#{ticker} was added.".green
				else
					puts "Could not find #{ticker} on Yahoo Fianance.".red
				end
			else
				puts "#{ticker} already exists and was not added.".yellow
			end
		end
  end

  desc "Add one stock with quotes since 2000-01-01. Stock ticker needs to be passed in as an argument, or pass in an environment variable, TICKERS, with multiple arguments.(TICKERS=QUOTE1,QUOTE1,QUOTE3)"
  task :add, [:ticker] => :environment do |t, args|
  	ticker = args[:ticker]
  	if ticker.class == String
  		add_stock(ticker)
		elsif ENV['TICKERS'].split(',').class == Array
			tickers = ENV['TICKERS'].split(',')
			tickers.each do |ticker|
				add_stock(ticker)
			end
	  end
	end



#################### Methods #################################3
	def add_stock(ticker)
		# check if stock exists in db
		if Stock.where(ticker: ticker).to_a.count == 0
			# get data from Yahoo Finance
			require 'open-uri'
			data = YahooFinance::get_historical_quotes(ticker, Date.parse( '2000-01-01' ), Date.today() )
			# check if ticker was found on Yahoo Finance
			if !data.empty?
				# chronologize the order
				quotes = data.reverse
				url = "http://www.bloomberg.com/quote/#{ticker}:US"
				doc = Nokogiri::HTML(open(url))
				# rescue the Nokogiri exception in case bloomberg doesn't have the correct data 
				begin
					description = doc.css(".profile").text
					company_name = doc.css(".ticker_header_top h2").text
				rescue => exception
					puts exception.message.red
					company_name = ticker
					description = "#{ticker} is a publicly traded S&P500 company."
				end

				attributes = {}
				attributes[:ticker] = ticker
				attributes[:company_name] = company_name
				attributes[:description] =  description
				attributes[:quotes] = quotes
				Stock.create(attributes)
				puts "#{ticker} was added.".green
			else
				puts "Could not find #{ticker} on Yahoo Fianance.".red
			end
		else
			puts "#{ticker} already exists and was not added.".yellow
		end
	end
############################# End Methods #####################	
end


# this takes forever to load into the db
###################### stock:get rake extended version########################
# This has to be scraped because have quotes as an embedded model is too slow

# sp500_tickers = ["ACN", "ACT", "ADBE", "ADT", "AES", "AET", "AFL", "A", "GAS", "APD", "ARG", "AKAM", "AA", "ALXN", "ATI", "AGN", "ALL", "ALTR", "MO", "AMZN", "AEE", "AEP", "AXP", "AIG", "AMT", "AMP", "ABC", "AME", "AMGN", "APH", "APC", "ADI", "AON", "APA", "AIV", "AAPL", "AMAT", "ADM", "AIZ", "T", "ADSK", "ADP", "AN", "AZO", "AVB", "AVY", "AVP", "BHI", "BLL", "BAC", "BK", "BCR", "BAX", "BBT", "BEAM", "BDX", "BBBY", "BMS", "BRK.B", "BBY", "BIIB", "BLK", "HRB", "BA", "BWA", "BXP", "BSX", "BMY", "BRCM", "BF.B", "CHRW", "CA", "CVC", "COG", "CAM", "CPB", "COF", "CAH", "CFN", "KMX", "CCL", "CAT", "CBG", "CBS", "CELG", "CNP", "CTL", "CERN", "CF", "SCHW", "CHK", "CVX", "CMG", "CB", "CI", "CINF", "CTAS", "CSCO", "C", "CTXS", "CLF", "CLX", "CME", "CMS", "COH", "KO", "CCE", "CTSH", "CL", "CMCSA", "CMA", "CSC", "CAG", "COP", "CNX", "ED", "STZ", "GLW", "COST", "COV", "CCI", "CSX", "CMI", "CVS", "DHI", "DHR", "DRI", "DVA", "DE", "DLPH", "DAL", "DNR", "XRAY", "DVN", "DO", "DTV", "DFS", "DISCA", "DG", "DLTR", "D", "DOV", "DOW", "DPS", "DTE", "DD", "DUK", "DNB", "ETFC", "EMN", "ETN", "EBAY", "ECL", "EIX", "EW", "EA", "EMC", "EMR", "ESV", "ETR", "EOG", "EQT", "EFX", "EQR", "EL", "EXC", "EXPE", "EXPD", "ESRX", "XOM", "FFIV", "FDO", "FAST", "FDX", "FIS", "FITB", "FSLR", "FE", "FISV", "FLIR", "FLS", "FLR", "FMC", "FTI", "F", "FRX", "FOSL", "BEN", "FCX", "FTR", "GME", "GCI", "GPS", "GRMN", "GD", "GE", "GIS", "GM", "GPC", "GNW", "GILD", "GS", "GT", "GOOG", "GWW", "HAL", "HOG", "HAR", "HRS", "HIG", "HAS", "HCP", "HCN", "HP", "HES", "HPQ", "HD", "HON", "HRL", "HSP", "HST", "HCBK", "HUM", "HBAN", "ITW", "IR", "TEG", "INTC", "ICE", "IBM", "IGT", "IP", "IPG", "IFF", "INTU", "ISRG", "IVZ", "IRM", "JBL", "JEC", "JDSU", "JNJ", "JCI", "JOY", "JPM", "JNPR", "KSU", "K", "KEY", "KMB", "KIM", "KMI", "KLAC", "KSS", "KRFT", "KR", "LTD", "LLL", "LH", "LRCX", "LM", "LEG", "LEN", "LUK", "LIFE", "LLY", "LNC", "LLTC", "LMT", "L", "LO", "LOW", "LSI", "LYB", "MTB", "MAC", "M", "MRO", "MPC", "MAR", "MMC", "MAS", "MA", "MAT", "MKC", "MCD", "MHFI", "MCK", "MJN", "MWV", "MDT", "MRK", "MET", "MCHP", "MU", "MSFT", "MOLX", "TAP", "MDLZ", "MON", "MNST", "MCO", "MS", "MOS", "MSI", "MUR", "MYL", "NBR", "NDAQ", "NOV", "NTAP", "NFLX", "NWL", "NFX", "NEM", "NWSA", "NEE", "NLSN", "NKE", "NI", "NE", "NBL", "JWN", "NSC", "NTRS", "NOC", "NU", "NRG", "NUE", "NVDA", "NYX", "ORLY", "OXY", "OMC", "OKE", "ORCL", "OI", "PCG", "PCAR", "PLL", "PH", "PDCO", "PAYX", "BTU", "JCP", "PNR", "PBCT", "POM", "PEP", "PKI", "PRGO", "PETM", "PFE", "PM", "PSX", "PNW", "PXD", "PBI", "PCL", "PNC", "RL", "PPG", "PPL", "PX", "PCP", "PCLN", "PFG", "PG", "PGR", "PLD", "PRU", "PEG", "PSA", "PHM", "PVH", "QEP", "PWR", "QCOM", "DGX", "RRC", "RTN", "RHT", "REGN", "RF", "RSG", "RAI", "RHI", "ROK", "COL", "ROP", "ROST", "RDC", "R", "SWY", "CRM", "SNDK", "SCG", "SLB", "SNI", "STX", "SEE", "SRE", "SHW", "SIAL", "SPG", "SLM", "SJM", "SNA", "SO", "LUV", "SWN", "SE", "STJ", "SWK", "SPLS", "SBUX", "HOT", "STT", "SRCL", "SYK", "STI", "SYMC", "SYY", "TROW", "TGT", "TEL", "TE", "THC", "TDC", "TER", "TSO", "TXN", "TXT", "HSY", "TRV", "TMO", "TIF", "TWX", "TWC", "TJX", "TMK", "TSS", "TRIP", "FOXA", "TSN", "TYC", "USB", "UNP", "UNH", "UPS", "X", "UTX", "UNM", "URBN", "VFC", "VLO", "VAR", "VTR", "VRSN", "VZ", "VRTX", "VIAB", "V", "VNO", "VMC", "WMT", "WAG", "DIS", "WPO", "WM", "WAT", "WLP", "WFC", "WDC", "WU", "WY", "WHR", "WFM", "WMB", "WIN", "WEC", "WPX", "WYN", "WYNN", "XEL", "XRX", "XLNX", "XL", "XYL", "YHOO", "YUM", "ZMH", "ZION", "ZTS"]
# sp500_names = ["Accenture plc", "Actavis plc", "Adobe Systems Inc", "ADT Corp", "AES Corp", "Aetna Inc", "AFLAC Inc", "Agilent Technologies Inc", "AGL Resources Inc.", "Air Products & Chemicals Inc", "Airgas Inc", "Akamai Technologies Inc", "Alcoa Inc", "Alexion Pharmaceuticals", "Allegheny Technologies Inc", "Allergan Inc", "Allstate Corp", "Altera Corp", "Altria Group Inc", "Amazon.com Inc", "Ameren Corp", "American Electric Power", "American Express Co", "American Intl Group Inc", "American Tower Corp A", "Ameriprise Financial", "AmerisourceBergen Corp", "Ametek", "Amgen Inc", "Amphenol Corp A", "Anadarko Petroleum Corp", "Analog Devices, Inc.", "Aon plc", "Apache Corporation", "Apartment Investment & Mgmt", "Apple Inc.", "Applied Materials Inc", "Archer-Daniels-Midland Co", "Assurant Inc", "AT&T Inc", "Autodesk Inc", "Automatic Data Processing", "AutoNation Inc", "AutoZone Inc", "AvalonBay Communities, Inc.", "Avery Dennison Corp", "Avon Products", "Baker Hughes Inc", "Ball Corp", "Bank of America Corp", "The Bank of New York Mellon Corp.", "Bard (C.R.) Inc.", "Baxter International Inc.", "BB&T Corporation", "Beam Inc.", "Becton Dickinson", "Bed Bath & Beyond", "Bemis Company", "Berkshire Hathaway", "Best Buy Co. Inc.", "BIOGEN IDEC Inc.", "BlackRock", "Block H&R", "Boeing Company", "BorgWarner", "Boston Properties", "Boston Scientific", "Bristol-Myers Squibb", "Broadcom Corporation", "Brown-Forman Corporation", "C. H. Robinson Worldwide", "CA, Inc.", "Cablevision Systems Corp.", "Cabot Oil & Gas", "Cameron International Corp.", "Campbell Soup", "Capital One Financial", "Cardinal Health Inc.", "Carefusion", "Carmax Inc", "Carnival Corp.", "Caterpillar Inc.", "CBRE Group", "CBS Corp.", "Celgene Corp.", "CenterPoint Energy", "CenturyLink Inc", "Cerner", "CF Industries Holdings Inc", "Charles Schwab", "Chesapeake Energy", "Chevron Corp.", "Chipotle Mexican Grill", "Chubb Corp.", "CIGNA Corp.", "Cincinnati Financial", "Cintas Corporation", "Cisco Systems", "Citigroup Inc.", "Citrix Systems", "Cliffs Natural Resources", "The Clorox Company", "CME Group Inc.", "CMS Energy", "Coach Inc.", "The Coca Cola Company", "Coca-Cola Enterprises", "Cognizant Technology Solutions", "Colgate-Palmolive", "Comcast Corp.", "Comerica Inc.", "Computer Sciences Corp.", "ConAgra Foods Inc.", "ConocoPhillips", "CONSOL Energy Inc.", "Consolidated Edison", "Constellation Brands", "Corning Inc.", "Costco Co.", "Covidien plc", "Crown Castle International Corp.", "CSX Corp.", "Cummins Inc.", "CVS Caremark Corp.", "D. R. Horton", "Danaher Corp.", "Darden Restaurants", "DaVita Inc.", "Deere & Co.", "Delphi Automotive", "Delta Air Lines", "Denbury Resources Inc.", "Dentsply International", "Devon Energy Corp.", "Diamond Offshore Drilling", "DirecTV", "Discover Financial Services", "Discovery Communications", "Dollar General", "Dollar Tree", "Dominion Resources", "Dover Corp.", "Dow Chemical", "Dr Pepper Snapple Group", "DTE Energy Co.", "Du Pont (E.I.)", "Duke Energy", "Dun & Bradstreet", "E-Trade", "Eastman Chemical", "Eaton Corp.", "eBay Inc.", "Ecolab Inc.", "Edison Int'l", "Edwards Lifesciences", "Electronic Arts", "EMC Corp.", "Emerson Electric", "Ensco plc", "Entergy Corp.", "EOG Resources", "EQT Corporation", "Equifax Inc.", "Equity Residential", "Estee Lauder Cos.", "Exelon Corp.", "Expedia Inc.", "Expeditors Int'l", "Express Scripts", "Exxon Mobil Corp.", "F5 Networks", "Family Dollar Stores", "Fastenal Co", "FedEx Corporation", "Fidelity National Information Services", "Fifth Third Bancorp", "First Solar Inc", "FirstEnergy Corp", "Fiserv Inc", "FLIR Systems", "Flowserve Corporation", "Fluor Corp.", "FMC Corporation", "FMC Technologies Inc.", "Ford Motor", "Forest Laboratories", "Fossil, Inc.", "Franklin Resources", "Freeport-McMoran Cp & Gld", "Frontier Communications", "GameStop Corp.", "Gannett Co.", "Gap (The)", "Garmin Ltd.", "General Dynamics", "General Electric", "General Mills", "General Motors", "Genuine Parts", "Genworth Financial Inc.", "Gilead Sciences", "Goldman Sachs Group", "Goodyear Tire & Rubber", "Google Inc.", "Grainger (W.W.) Inc.", "Halliburton Co.", "Harley-Davidson", "Harman Int'l Industries", "Harris Corporation", "Hartford Financial Svc.Gp.", "Hasbro Inc.", "HCP Inc.", "Health Care REIT", "Helmerich & Payne", "Hess Corporation", "Hewlett-Packard", "Home Depot", "Honeywell Int'l Inc.", "Hormel Foods Corp.", "Hospira Inc.", "Host Hotels & Resorts", "Hudson City Bancorp", "Humana Inc.", "Huntington Bancshares", "Illinois Tool Works", "Ingersoll-Rand PLC", "Integrys Energy Group Inc.", "Intel Corp.", "IntercontinentalExchange Inc.", "International Bus. Machines", "International Game Technology", "International Paper", "Interpublic Group", "Intl Flavors & Fragrances", "Intuit Inc.", "Intuitive Surgical Inc.", "Invesco Ltd.", "Iron Mountain Incorporated", "Jabil Circuit", "Jacobs Engineering Group", "JDS Uniphase Corp.", "Johnson & Johnson", "Johnson Controls", "Joy Global Inc.", "JPMorgan Chase & Co.", "Juniper Networks", "Kansas City Southern", "Kellogg Co.", "KeyCorp", "Kimberly-Clark", "Kimco Realty", "Kinder Morgan", "KLA-Tencor Corp.", "Kohl's Corp.", "Kraft Foods Group", "Kroger Co.", "L Brands Inc.", "L-3 Communications Holdings", "Laboratory Corp. of America Holding", "Lam Research", "Legg Mason", "Leggett & Platt", "Lennar Corp.", "Leucadia National Corp.", "Life Technologies", "Lilly (Eli) & Co.", "Lincoln National", "Linear Technology Corp.", "Lockheed Martin Corp.", "Loews Corp.", "Lorillard Inc.", "Lowe's Cos.", "LSI Corporation", "LyondellBasell", "M&T Bank Corp.", "Macerich", "Macy's Inc.", "Marathon Oil Corp.", "Marathon Petroleum", "Marriott Int'l.", "Marsh & McLennan", "Masco Corp.", "Mastercard Inc.", "Mattel Inc.", "McCormick & Co.", "McDonald's Corp.", "McGraw Hill Financial", "McKesson Corp.", "Mead Johnson", "MeadWestvaco Corporation", "Medtronic Inc.", "Merck & Co.", "MetLife Inc.", "Microchip Technology", "Micron Technology", "Microsoft Corp.", "Molex Inc.", "Molson Coors Brewing Company", "Mondelez International", "Monsanto Co.", "Monster Beverage", "Moody's Corp", "Morgan Stanley", "The Mosaic Company", "Motorola Solutions Inc.", "Murphy Oil", "Mylan Inc.", "Nabors Industries Ltd.", "NASDAQ OMX Group", "National Oilwell Varco Inc.", "NetApp", "NetFlix Inc.", "Newell Rubbermaid Co.", "Newfield Exploration Co", "Newmont Mining Corp. (Hldg. Co.)", "News Corporation", "NextEra Energy Resources", "Nielsen Holdings", "NIKE Inc.", "NiSource Inc.", "Noble Corp", "Noble Energy Inc", "Nordstrom", "Norfolk Southern Corp.", "Northern Trust Corp.", "Northrop Grumman Corp.", "Northeast Utilities", "NRG Energy", "Nucor Corp.", "Nvidia Corporation", "NYSE Euronext", "O'Reilly Automotive", "Occidental Petroleum", "Omnicom Group", "ONEOK", "Oracle Corp.", "Owens-Illinois Inc", "P G & E Corp.", "PACCAR Inc.", "Pall Corp.", "Parker-Hannifin", "Patterson Companies", "Paychex Inc.", "Peabody Energy", "Penney (J.C.)", "Pentair Ltd.", "People's United Bank", "Pepco Holdings Inc.", "PepsiCo Inc.", "PerkinElmer", "Perrigo", "PetSmart, Inc.", "Pfizer Inc.", "Philip Morris International", "Phillips 66", "Pinnacle West Capital", "Pioneer Natural Resources", "Pitney-Bowes", "Plum Creek Timber Co.", "PNC Financial Services", "Polo Ralph Lauren Corp.", "PPG Industries", "PPL Corp.", "Praxair Inc.", "Precision Castparts", "Priceline.com Inc", "Principal Financial Group", "Procter & Gamble", "Progressive Corp.", "Prologis", "Prudential Financial", "Public Serv. Enterprise Inc.", "Public Storage", "Pulte Homes Inc.", "PVH Corp.", "QEP Resources", "Quanta Services Inc.", "QUALCOMM Inc.", "Quest Diagnostics", "Range Resources Corp.", "Raytheon Co.", "Red Hat Inc.", "Regeneron", "Regions Financial Corp.", "Republic Services Inc", "Reynolds American Inc.", "Robert Half International", "Rockwell Automation Inc.", "Rockwell Collins", "Roper Industries", "Ross Stores", "Rowan Cos.", "Ryder System", "Safeway Inc.", "Salesforce.com", "SanDisk Corporation", "SCANA Corp", "Schlumberger Ltd.", "Scripps Networks Interactive Inc.", "Seagate Technology", "Sealed Air Corp.(New)", "Sempra Energy", "Sherwin-Williams", "Sigma-Aldrich", "Simon Property Group Inc", "SLM Corporation", "Smucker (J.M.)", "Snap-On Inc.", "Southern Co.", "Southwest Airlines", "Southwestern Energy", "Spectra Energy Corp.", "St Jude Medical", "Stanley Black & Decker", "Staples Inc.", "Starbucks Corp.", "Starwood Hotels & Resorts", "State Street Corp.", "Stericycle Inc", "Stryker Corp.", "SunTrust Banks", "Symantec Corp.", "Sysco Corp.", "T. Rowe Price Group", "Target Corp.", "TE Connectivity Ltd.", "TECO Energy", "Tenet Healthcare Corp.", "Teradata Corp.", "Teradyne Inc.", "Tesoro Petroleum Co.", "Texas Instruments", "Textron Inc.", "The Hershey Company", "The Travelers Companies Inc.", "Thermo Fisher Scientific", "Tiffany & Co.", "Time Warner Inc.", "Time Warner Cable Inc.", "TJX Companies Inc.", "Torchmark Corp.", "Total System Services", "TripAdvisor", "Twenty-First Century Fox", "Tyson Foods", "Tyco International", "U.S. Bancorp", "Union Pacific", "United Health Group Inc.", "United Parcel Service", "United States Steel Corp.", "United Technologies", "Unum Group", "Urban Outfitters", "V.F. Corp.", "Valero Energy", "Varian Medical Systems", "Ventas Inc", "Verisign Inc.", "Verizon Communications", "Vertex Pharmaceuticals Inc", "Viacom Inc.", "Visa Inc.", "Vornado Realty Trust", "Vulcan Materials", "Wal-Mart Stores", "Walgreen Co.", "The Walt Disney Company", "Washington Post Co B", "Waste Management Inc.", "Waters Corporation", "WellPoint Inc.", "Wells Fargo", "Western Digital", "Western Union Co", "Weyerhaeuser Corp.", "Whirlpool Corp.", "Whole Foods Market", "Williams Cos.", "Windstream Communications", "Wisconsin Energy Corporation", "WPX Energy, Inc.", "Wyndham Worldwide", "Wynn Resorts Ltd", "Xcel Energy Inc", "Xerox Corp.", "Xilinx Inc", "XL Capital", "Xylem Inc.", "Yahoo Inc.", "Yum! Brands Inc", "Zimmer Holdings", "Zions Bancorp", "Zoetis"]

# sp500_tickers.take(1).each_with_index do |ticker,index|
# 	ticker = ticker.downcase
# 	url = "https://www.google.com/finance?q=#{ticker}&ei=twR_UqjCK6qB0QG2Lg"
# 	doc = Nokogiri::HTML(open(url))
# 	description = doc.css(".companySummary").first.children.first.text
# 	information = {}
# 	information[:ticker] = ticker
# 	information[:company_name] = sp500_names[index]
# 	information[:description] =  description
	

# 	stock = Stock.create(information)

# 	data = YahooFinance::get_historical_quotes(ticker.upcase, Date.parse( '2000-01-01' ), Date.today() )
# RubyProf.start
# 	data.reverse.each_with_index do |day, index|
# 		stock.quotes.create(
# 			id: index + 1,
# 		  date: day[0],
# 		  open: day[1],
# 		  high: day[2],
# 		  low: day[3],
# 		  close: day[4],
# 		  volume: day[5],
# 		  adjusted: day[6]
# 		  )
# 	end
# result = RubyProf.stop
# printer = RubyProf::FlatPrinter.new(result)
# printer.print(STDOUT)
# end

####################### End Seed Version1.0#####################