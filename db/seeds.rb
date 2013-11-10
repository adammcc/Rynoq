
Stock.delete_all

# data = YahooFinance::get_historical_quotes_days( 'GOOG', 10 )
data = [["2013-11-08","1008.75","1018.50","1008.50","1016.03","1290800","1016.03"],
 ["2013-11-07","1022.61","1023.93","1007.64","1007.95","1679600","1007.95"],
 ["2013-11-06","1025.60","1027.00","1015.37","1022.75","912900","1022.75"],
 ["2013-11-05","1020.35","1031.65","1017.42","1021.52","1181400","1021.52"],
 ["2013-11-04","1031.50","1032.37","1022.03","1026.11","1138800","1026.11"],
 ["2013-11-01","1031.79","1036.00","1025.10","1027.04","1283300","1027.04"],
 ["2013-10-31","1028.93","1041.52","1023.97","1030.58","1616400","1030.58"],
 ["2013-10-30","1037.43","1037.51","1026.00","1030.42","1324100","1030.42"]]


information = {company_name: 'Google inc.', ticker: 'GOOG', description: "Google Inc. (Google) is a global technology company. The Company’s business is primarily focused around key areas, such as search, advertising, operating systems and platforms, enterprise and hardware products. The Company generates revenue primarily by delivering online advertising. The Company provides its products and services in more than 100 languages and in more than 50 countries, regions, and territories. The Company’s Motorola business consists of two segments: Mobile segment and Home segment. The Mobile segment is focused on mobile wireless devices and related products and services. The Home segment is focused on technologies and devices that provide video entertainment services to consumers by enabling subscribers to access a variety of interactive digital television services. Effective September 16, 2013, Google Inc acquired Bump Technologies Inc. Effective October 22, 2013, Google Inc acquired FlexyCore, a developer of software."}

goog = Stock.create(information)

data.reverse.each_with_index do |day, index|
	goog.quotes.create(
		id: index + 1,
	  date: day[0],
	  open: day[1],
	  high: day[2],
	  low: day[3],
	  close: day[4],
	  volume: day[5],
	  adjusted: day[6]
	  )
end

#************************Historical**************************************
#************************************************************************
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

#************************Standard****************************************
#************************************************************************
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

#************************Extended****************************************
#************************************************************************
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


############################# S&P 500 #############################
# ["MMM", "ABT", "ABBV", "ANF", "ACE", "ACN", "ACT", "ADBE", "ADT", "AES", "AET", "AFL", "A", "GAS", "APD", "ARG", "AKAM", "AA", "ALXN", "ATI", "AGN", "ALL", "ALTR", "MO", "AMZN", "AEE", "AEP", "AXP", "AIG", "AMT", "AMP", "ABC", "AME", "AMGN", "APH", "APC", "ADI", "AON", "APA", "AIV", "AAPL", "AMAT", "ADM", "AIZ", "T", "ADSK", "ADP", "AN", "AZO", "AVB", "AVY", "AVP", "BHI", "BLL", "BAC", "BK", "BCR", "BAX", "BBT", "BEAM", "BDX", "BBBY", "BMS", "BRK.B", "BBY", "BIIB", "BLK", "HRB", "BA", "BWA", "BXP", "BSX", "BMY", "BRCM", "BF.B", "CHRW", "CA", "CVC", "COG", "CAM", "CPB", "COF", "CAH", "CFN", "KMX", "CCL", "CAT", "CBG", "CBS", "CELG", "CNP", "CTL", "CERN", "CF", "SCHW", "CHK", "CVX", "CMG", "CB", "CI", "CINF", "CTAS", "CSCO", "C", "CTXS", "CLF", "CLX", "CME", "CMS", "COH", "KO", "CCE", "CTSH", "CL", "CMCSA", "CMA", "CSC", "CAG", "COP", "CNX", "ED", "STZ", "GLW", "COST", "COV", "CCI", "CSX", "CMI", "CVS", "DHI", "DHR", "DRI", "DVA", "DE", "DELL", "DLPH", "DAL", "DNR", "XRAY", "DVN", "DO", "DTV", "DFS", "DISCA", "DG", "DLTR", "D", "DOV", "DOW", "DPS", "DTE", "DD", "DUK", "DNB", "ETFC", "EMN", "ETN", "EBAY", "ECL", "EIX", "EW", "EA", "EMC", "EMR", "ESV", "ETR", "EOG", "EQT", "EFX", "EQR", "EL", "EXC", "EXPE", "EXPD", "ESRX", "XOM", "FFIV", "FDO", "FAST", "FDX", "FIS", "FITB", "FSLR", "FE", "FISV", "FLIR", "FLS", "FLR", "FMC", "FTI", "F", "FRX", "FOSL", "BEN", "FCX", "FTR", "GME", "GCI", "GPS", "GRMN", "GD", "GE", "GIS", "GM", "GPC", "GNW", "GILD", "GS", "GT", "GOOG", "GWW", "HAL", "HOG", "HAR", "HRS", "HIG", "HAS", "HCP", "HCN", "HP", "HES", "HPQ", "HD", "HON", "HRL", "HSP", "HST", "HCBK", "HUM", "HBAN", "ITW", "IR", "TEG", "INTC", "ICE", "IBM", "IGT", "IP", "IPG", "IFF", "INTU", "ISRG", "IVZ", "IRM", "JBL", "JEC", "JDSU", "JNJ", "JCI", "JOY", "JPM", "JNPR", "KSU", "K", "KEY", "KMB", "KIM", "KMI", "KLAC", "KSS", "KRFT", "KR", "LTD", "LLL", "LH", "LRCX", "LM", "LEG", "LEN", "LUK", "LIFE", "LLY", "LNC", "LLTC", "LMT", "L", "LO", "LOW", "LSI", "LYB", "MTB", "MAC", "M", "MRO", "MPC", "MAR", "MMC", "MAS", "MA", "MAT", "MKC", "MCD", "MHFI", "MCK", "MJN", "MWV", "MDT", "MRK", "MET", "MCHP", "MU", "MSFT", "MOLX", "TAP", "MDLZ", "MON", "MNST", "MCO", "MS", "MOS", "MSI", "MUR", "MYL", "NBR", "NDAQ", "NOV", "NTAP", "NFLX", "NWL", "NFX", "NEM", "NWSA", "NEE", "NLSN", "NKE", "NI", "NE", "NBL", "JWN", "NSC", "NTRS", "NOC", "NU", "NRG", "NUE", "NVDA", "NYX", "ORLY", "OXY", "OMC", "OKE", "ORCL", "OI", "PCG", "PCAR", "PLL", "PH", "PDCO", "PAYX", "BTU", "JCP", "PNR", "PBCT", "POM", "PEP", "PKI", "PRGO", "PETM", "PFE", "PM", "PSX", "PNW", "PXD", "PBI", "PCL", "PNC", "RL", "PPG", "PPL", "PX", "PCP", "PCLN", "PFG", "PG", "PGR", "PLD", "PRU", "PEG", "PSA", "PHM", "PVH", "QEP", "PWR", "QCOM", "DGX", "RRC", "RTN", "RHT", "REGN", "RF", "RSG", "RAI", "RHI", "ROK", "COL", "ROP", "ROST", "RDC", "R", "SWY", "CRM", "SNDK", "SCG", "SLB", "SNI", "STX", "SEE", "SRE", "SHW", "SIAL", "SPG", "SLM", "SJM", "SNA", "SO", "LUV", "SWN", "SE", "STJ", "SWK", "SPLS", "SBUX", "HOT", "STT", "SRCL", "SYK", "STI", "SYMC", "SYY", "TROW", "TGT", "TEL", "TE", "THC", "TDC", "TER", "TSO", "TXN", "TXT", "HSY", "TRV", "TMO", "TIF", "TWX", "TWC", "TJX", "TMK", "TSS", "TRIP", "FOXA", "TSN", "TYC", "USB", "UNP", "UNH", "UPS", "X", "UTX", "UNM", "URBN", "VFC", "VLO", "VAR", "VTR", "VRSN", "VZ", "VRTX", "VIAB", "V", "VNO", "VMC", "WMT", "WAG", "DIS", "WPO", "WM", "WAT", "WLP", "WFC", "WDC", "WU", "WY", "WHR", "WFM", "WMB", "WIN", "WEC", "WPX", "WYN", "WYNN", "XEL", "XRX", "XLNX", "XL", "XYL", "YHOO", "YUM", "ZMH", "ZION", "ZTS"]