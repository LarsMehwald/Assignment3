########################
# Lars Mehwald and Daniel Salgado Moreno
# 11 December 2015
# Population by Nationality, Gender and Age
########################

# Loading the data
Foreigners <- read.csv(file="Analysis/data/RawData/173-41-4_Auslaender_by_age_and_gender_3.csv",
                        sep=";", 
                        dec=",",
                        na.strings=c("."), 
                        header = FALSE,
                        skip=8,
                        nrows = 9422, 
                        col.names = c("year", 
                                      "district", 
                                      "DistrictName", 
                                      "Agegroup", 
                                      "ForeignersTotal", 
                                      "ForeignersMale", 
                                      "ForeignersFemale")
)

# Keeping only Total for Agegroup
Foreigners <- Foreigners[c(18,
                           36,
                           54,
                           72,
                           90,
                           108,
                           126,
                           144,
                           162,
                           180,
                           198,
                           216,
                           234,
                           252,
                           270,
                           288,
                           306,
                           324,
                           342,
                           360,
                           378,
                           396,
                           414,
                           432,
                           450,
                           468,
                           486,
                           504,
                           522,
                           540,
                           558,
                           576,
                           594,
                           612,
                           630,
                           648,
                           666,
                           684,
                           702,
                           720,
                           738,
                           756,
                           774,
                           792,
                           810,
                           828,
                           846,
                           864,
                           882,
                           900,
                           918,
                           936,
                           954,
                           972,
                           990,
                           1008,
                           1026,
                           1044,
                           1062,
                           1080,
                           1098,
                           1116,
                           1134,
                           1152,
                           1170,
                           1188,
                           1206,
                           1224,
                           1242,
                           1260,
                           1278,
                           1296,
                           1314,
                           1332,
                           1350,
                           1368,
                           1386,
                           1404,
                           1422,
                           1440,
                           1458,
                           1476,
                           1494,
                           1512,
                           1530,
                           1548,
                           1566,
                           1584,
                           1602,
                           1620,
                           1638,
                           1656,
                           1674,
                           1692,
                           1710,
                           1728,
                           1746,
                           1764,
                           1782,
                           1800,
                           1818,
                           1836,
                           1854,
                           1872,
                           1890,
                           1908,
                           1926,
                           1944,
                           1962,
                           1980,
                           1998,
                           2016,
                           2034,
                           2052,
                           2070,
                           2088,
                           2106,
                           2124,
                           2142,
                           2160,
                           2178,
                           2196,
                           2214,
                           2232,
                           2250,
                           2268,
                           2286,
                           2304,
                           2322,
                           2340,
                           2358,
                           2376,
                           2394,
                           2412,
                           2430,
                           2448,
                           2466,
                           2484,
                           2502,
                           2520,
                           2538,
                           2556,
                           2574,
                           2592,
                           2610,
                           2628,
                           2646,
                           2664,
                           2682,
                           2700,
                           2718,
                           2736,
                           2754,
                           2772,
                           2790,
                           2808,
                           2826,
                           2844,
                           2862,
                           2880,
                           2898,
                           2916,
                           2934,
                           2952,
                           2970,
                           2988,
                           3006,
                           3024,
                           3042,
                           3060,
                           3078,
                           3096,
                           3114,
                           3132,
                           3150,
                           3168,
                           3186,
                           3204,
                           3222,
                           3240,
                           3258,
                           3276,
                           3294,
                           3312,
                           3330,
                           3348,
                           3366,
                           3384,
                           3402,
                           3420,
                           3438,
                           3456,
                           3474,
                           3492,
                           3510,
                           3528,
                           3546,
                           3564,
                           3582,
                           3600,
                           3618,
                           3636,
                           3654,
                           3672,
                           3690,
                           3708,
                           3726,
                           3744,
                           3762,
                           3780,
                           3798,
                           3816,
                           3834,
                           3852,
                           3870,
                           3888,
                           3906,
                           3924,
                           3942,
                           3960,
                           3978,
                           3996,
                           4014,
                           4032,
                           4050,
                           4068,
                           4086,
                           4104,
                           4122,
                           4140,
                           4158,
                           4176,
                           4194,
                           4212,
                           4230,
                           4248,
                           4266,
                           4284,
                           4302,
                           4320,
                           4338,
                           4356,
                           4374,
                           4392,
                           4410,
                           4428,
                           4446,
                           4464,
                           4482,
                           4500,
                           4518,
                           4536,
                           4554,
                           4572,
                           4590,
                           4608,
                           4626,
                           4644,
                           4662,
                           4680,
                           4698,
                           4716,
                           4734,
                           4752,
                           4770,
                           4788,
                           4806,
                           4824,
                           4842,
                           4860,
                           4878,
                           4896,
                           4914,
                           4932,
                           4950,
                           4968,
                           4986,
                           5004,
                           5022,
                           5040,
                           5058,
                           5076,
                           5094,
                           5112,
                           5130,
                           5148,
                           5166,
                           5184,
                           5202,
                           5220,
                           5238,
                           5256,
                           5274,
                           5292,
                           5310,
                           5328,
                           5346,
                           5364,
                           5382,
                           5400,
                           5418,
                           5436,
                           5454,
                           5472,
                           5490,
                           5508,
                           5526,
                           5544,
                           5562,
                           5580,
                           5598,
                           5616,
                           5634,
                           5652,
                           5670,
                           5688,
                           5706,
                           5724,
                           5742,
                           5760,
                           5778,
                           5796,
                           5814,
                           5832,
                           5850,
                           5868,
                           5886,
                           5904,
                           5922,
                           5940,
                           5958,
                           5976,
                           5994,
                           6012,
                           6030,
                           6048,
                           6066,
                           6084,
                           6102,
                           6120,
                           6138,
                           6156,
                           6174,
                           6192,
                           6210,
                           6228,
                           6246,
                           6264,
                           6282,
                           6300,
                           6318,
                           6336,
                           6354,
                           6372,
                           6390,
                           6408,
                           6426,
                           6444,
                           6462,
                           6480,
                           6498,
                           6516,
                           6534,
                           6552,
                           6570,
                           6588,
                           6606,
                           6624,
                           6642,
                           6660,
                           6678,
                           6696,
                           6714,
                           6732,
                           6750,
                           6768,
                           6786,
                           6804,
                           6822,
                           6840,
                           6858,
                           6876,
                           6894,
                           6912,
                           6930,
                           6948,
                           6966,
                           6984,
                           7002,
                           7020,
                           7038,
                           7056,
                           7074,
                           7092,
                           7110,
                           7128,
                           7146,
                           7164,
                           7182,
                           7200,
                           7218,
                           7236,
                           7254,
                           7272,
                           7290,
                           7308,
                           7326,
                           7344,
                           7362,
                           7380,
                           7398,
                           7416,
                           7434,
                           7452,
                           7470,
                           7488,
                           7506,
                           7524,
                           7542,
                           7560,
                           7578,
                           7596,
                           7614,
                           7632,
                           7650,
                           7668,
                           7686,
                           7704,
                           7722,
                           7740,
                           7758,
                           7776,
                           7794,
                           7812,
                           7830,
                           7848,
                           7866,
                           7884,
                           7902,
                           7920,
                           7938,
                           7956,
                           7974,
                           7992,
                           8010,
                           8028,
                           8046,
                           8064,
                           8082,
                           8100,
                           8118,
                           8136,
                           8154,
                           8172,
                           8190,
                           8208,
                           8226,
                           8244,
                           8262,
                           8280,
                           8298,
                           8316,
                           8334,
                           8352,
                           8370,
                           8388,
                           8406,
                           8424,
                           8442,
                           8460,
                           8478,
                           8496,
                           8514,
                           8532,
                           8550,
                           8568,
                           8586,
                           8604,
                           8622,
                           8640,
                           8658,
                           8676,
                           8694,
                           8712,
                           8730,
                           8748,
                           8766,
                           8784,
                           8802,
                           8820,
                           8838,
                           8856,
                           8874,
                           8892,
                           8910,
                           8928,
                           8946,
                           8964,
                           8982,
                           9000,
                           9018,
                           9036,
                           9054,
                           9072,
                           9090,
                           9108,
                           9126,
                           9144,
                           9162,
                           9180,
                           9198,
                           9216,
                           9234,
                           9252,
                           9270,
                           9288,
                           9306,
                           9324,
                           9342,
                           9360,
                           9378,
                           9396,
                           9414),]

# Removing Agegroup Variable
Foreigners <- Foreigners[,c(1,2,3,5,6,7)]

# Converting Character Vectors between Encodings from latin1 to UTF-8
# More compatibility with German characters
Foreigners$DistrictName <- iconv(Foreigners$DistrictName, from ="latin1", to = "UTF-8")

# Removing higher political units (they are coded with numbers below 1000)
# Keeping only district$Berlin = 11; district$Hamburg = 2; 
ForeignersBerHam <- subset(Foreigners, Foreigners$district == 2 | Foreigners$district ==11, all(TRUE))
Foreigners <- Foreigners[Foreigners$district > 1000,]
Foreigners <- rbind(Foreigners, ForeignersBerHam)
rm(ForeignersBerHam)

# Removing redundant districts
# (We keep for district$Aachen=5334, district$Hannover=3241, district$Saarbrücken=10041)
Foreigners <- subset(Foreigners, Foreigners$district < 17000, all(TRUE))

#Removing some variables 
Foreigners <- Foreigners[,-c(3,5,6)]

# Changing the class of some variables to numeric 
Foreigners[,1] <- as.numeric(as.character(Foreigners[,1]))
Foreigners[,2] <- as.numeric(as.character(Foreigners[,2]))
Foreigners[,3] <- as.numeric(as.character(Foreigners[,3]))

# Saving the data 
write.csv(Foreigners, file = "Analysis/data/Foreigners.csv")
