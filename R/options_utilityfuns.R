## DEFINE SOME OPTIONS

# screen aspect ratio & initial X & Y limits
aspect_ratio = as.double(13/9) # first had 16/9 but take into account window on the right that needs space too
xlims <- c(-2.0, 2.0)*aspect_ratio
ylims <- c(-2.0, 2.0)
oldxlims <- c(0,0)

# pre-generated palettes
mandelbrot_palette=function(palette, fold = TRUE,
                            reps = 1L, in_set = "black") {
  
  if (!fold %in% c(TRUE, FALSE)) {
    stop("Fold must be TRUE or FALSE")
  }
  
  if (length(palette) < 1000) {
    palette <- grDevices::colorRampPalette(palette)(1000)
  }
  
  if (fold) {
    palette <- c(palette, rev(palette))
  }
  
  c(rep(palette, reps), in_set)
}

rainbow=c(rgb(0.47,0.11,0.53),rgb(0.27,0.18,0.73),rgb(0.25,0.39,0.81),rgb(0.30,0.57,0.75),rgb(0.39,0.67,0.60),rgb(0.51,0.73,0.44),rgb(0.67,0.74,0.32),rgb(0.81,0.71,0.26),rgb(0.89,0.60,0.22),rgb(0.89,0.39,0.18),rgb(0.86,0.13,0.13))

earthsky = c( # from https://github.com/leamare/mandelbrot-experiment-dlang/blob/main/source/mandel.d
  rgb(66, 30, 15, maxColorValue = 255),
  rgb(25, 7, 26, maxColorValue = 255),
  rgb(9, 1, 47, maxColorValue = 255),
  rgb(4, 4, 7, maxColorValue = 2553),
  rgb(0, 7, 10, maxColorValue = 2550),
  rgb(12, 44, 13, maxColorValue = 2558),
  rgb(24, 82, 177, maxColorValue = 255),
  rgb(57, 125, 209, maxColorValue = 255),
  rgb(134, 181, 229, maxColorValue = 255),
  rgb(211, 236, 248, maxColorValue = 255),
  rgb(241, 233, 191, maxColorValue = 255),
  rgb(248, 201, 95, maxColorValue = 255),
  rgb(255, 170, 0, maxColorValue = 255),
  rgb(204, 128, 0, maxColorValue = 255),
  rgb(153, 87, 0, maxColorValue = 255),
  rgb(106, 52, 3, maxColorValue = 255)
)

seashore=c(rgb(0.7909, 0.9961, 0.763),
           rgb(0.8974, 0.8953, 0.6565),
           rgb(0.9465, 0.3161, 0.1267),
           rgb(0.5184, 0.1109, 0.0917),
           rgb(0.0198, 0.4563, 0.6839),
           rgb(0.5385, 0.8259, 0.8177))

fire=c(rgb(0, 0, 0),
       rgb(1, 0, 0),
       rgb(1, 1, 0),
       rgb(1, 1, 1),
       rgb(1, 1, 0),
       rgb(1, 0, 0))

oceanid=c(rgb(0, 0, 0),
          rgb(0, 0, 1),
          rgb(0, 1, 1),
          rgb(1, 1, 1),
          rgb(0, 1, 1),
          rgb(0, 0, 1))

cnfsso=c(rgb(244, 241, 222, maxColorValue=255),
         rgb(224, 122, 95, maxColorValue=255),
         rgb(61, 64, 91, maxColorValue=255),
         rgb(129, 178, 154, maxColorValue=255),
         rgb(242, 204, 143, maxColorValue=255))

acid=c(rgb(239, 71, 111, maxColorValue=255),
       rgb(255, 209, 102, maxColorValue=255),
       rgb(6, 214, 160, maxColorValue=255),
       rgb(17, 138, 178, maxColorValue=255),
       rgb(7, 59, 76, maxColorValue=255))

palettes <- list( 
  Lava = c( # best with gamma=1/8, darker red with gamma=1/20
    grey.colors(1000, start = .3, end = 1),
    colorRampPalette(RColorBrewer::brewer.pal(9, "YlOrRd"), bias=1)(1000), 
    "black"),
  Ice =  mandelbrot_palette(rev(RColorBrewer::brewer.pal(11, "RdYlBu"))), # best with gamma=1/8
  Rainbow = c(colorRampPalette(rainbow)(1000),rev(colorRampPalette(rainbow)(1000)),"black"), # best with gamma=1/8 , gamma=1.5 gives more psychedelic effect, gamma=0.5 more purple
  Spectral = mandelbrot_palette(RColorBrewer::brewer.pal(11, "Spectral")), # best with gamma=1/8
  EarthSky = mandelbrot_palette(colorRampPalette(earthsky)(1000)),  # best with gamma=0.2, with gamma=1 becomes more psychedelic
  Seashore = mandelbrot_palette(colorRampPalette(seashore)(1000)), # best with gamma=1/3
  Fire = mandelbrot_palette(colorRampPalette(fire)(1000)), # best with gamma=1/18
  OceanId = mandelbrot_palette(colorRampPalette(oceanid)(1000)), # best with gamma=1/8
  Cnfsso = mandelbrot_palette(colorRampPalette(cnfsso)(1000)), # best with gamma=1/8
  Acid = mandelbrot_palette(colorRampPalette(acid)(1000)) #OK with gamma=1/8, gamma=1.5 gives more psychedelic effect
)


# a list of 73 cool x and y pairs
x = list(xlims=c(-0.766032578179731,-0.766032578179529),
         xlims = c(-0.74877, -0.74872),
         xlims = c(0.366371018274633,0.366371033044207),
         xlims=c(0.143556213026305,0.143556215953355),
         xlims=c(-0.483160552536832,-0.483160552536658),
         xlims=c(0.385137743606138,0.385137743766312),
         xlims=c(-0.732579418321346,-0.732579418320854),
         xlims=c(-1.95362863644824,-1.95362859340036),
         xlims=c(-0.980588241840019,-0.980588236678861),
         xlims=c(0.372466075032996,0.372466075034454),
         xlims=c(-0.755530652254736,-0.755530652250714),
         xlims=c(0.412790462348917,0.412790462352773),
         xlims=c(-0.749712051314118,-0.749712051313332),
         xlims=c(-0.456302013521041,-0.456302013520289),
         xlims=c(-0.859250587697113,-0.859250587695727),
         xlims=c(-1.26425834686472,-1.26425832633208),
         
         # xlims=c(-0.692054890713434,-0.692054890712223), # r=17, would need more iterations, # some points from https://math.hws.edu/eck/js/mandelbrot/java/MandelbrotSettings/index.html
         xlims=c(-0.65343765618915,-0.653437652040648),
         xlims=c(0.250871903568899,0.250871903570282),
         xlims=c(0.29483187789975,0.29483187801813),
         xlims=c(-1.98381015514276,-1.98381015514265)-1E-13, 
         xlims=c(-0.745019842305853,-0.745019842305326),
         xlims=c(-0.839415805052836,-0.839415805047825),
         xlims=c(-0.737724728814343,-0.73772472880948),
         xlims=c(0.318409338151291,0.318409338151636),
         xlims=c(-1.67440967370494,-1.67440967368573),
         xlims=c(-1.62578301899646,-1.6257830180867),
         xlims=c(-1.47465525048349,-1.47465525020674),
         xlims=c(-0.787874953201062,-0.787874950351207),
         xlims=c(-0.648694453429374,-0.648694453428863),
         xlims=c(-1.78596750561962,-1.78596750561359),
         xlims=c(-0.593652780438166,-0.593652780433243),
         xlims=c(0.295904674394739,0.295904679731141),
         # xlims=c(-1.39963410887383,-1.39963410886616), # would need more iterations
         xlims=c(-1.78569305221743,-1.78569305221593),
         xlims=c(-1.9408980146618,-1.94089801382533),
         xlims=c(-0.112207662789484,-0.112207662787872),
         xlims=c(-0.914670637256626,-0.914670637255815),
         xlims=c(-0.799084828438107,-0.799084828437988),
         xlims=c(-1.78359043171397,-1.78359043170652),
         xlims=c(-1.62860853906417,-1.6286085354757),
         xlims=c(-1.94131964805603,-1.94131961301901),
         xlims=c(-1.94218895273924,-1.94218895272777),
         xlims=c(-1.62421570904188,-1.62421570904167),
         xlims=c(-0.745294029134114,-0.745227576497395),
         xlims=c(-0.531557429668032,-0.531557429564192),
         xlims=c(0.250580620580998,0.25058062246532),
         xlims=c(-1.47973723070311,-1.47973706782529),
         xlims=c(-0.749986852018818,-0.749986852014856),
         xlims=c(-0.15375428693559,-0.15375428691259), # would ideally need more iterations
         xlims=c(0.252404730012211,0.252404736455685),
         xlims=c(-1.36789290442292,-1.36789290438756),
         xlims=c(0.273771332381423,0.273771332946091),
         xlims=c(0.286015601670645,0.286015601719151),
         xlims=c(-1.46119815193401,-1.46119815193343),
         xlims=c(0.370344196621962,0.370344196628394),
         xlims=c(0.300792861590402,0.30079286172834),
         xlims=c(0.347610822323866,0.347610822324533),
         xlims=c(-1.63238432698718,-1.6323843267455),
         xlims=c(-0.69147272982691,-0.691472729809904),
         # xlims=c(-0.109329365789381,-0.109329365635221), # would need more iterations
         xlims=c(-0.984513852432589,-0.984513852426629),
         xlims=c(-1.24026705002251,-1.24026704737274),
         xlims=c(-0.840953330409027,-0.840953329407727),
         xlims=c(-1.99637522106598,-1.99637522106568)+6E-14, 
         xlims=c(0.414418290596453,0.414418290596663)+5E-14, 
         xlims=c(0.253102455884952,0.253102464729353),
         xlims=c(0.292781664906807,0.292781664907297),
         xlims=c(-0.500729300836675,-0.500729224213008),
         xlims=c(-1.74871562810233,-1.74871562810069),
         xlims=c(0.257404386342656,0.257404573571822),
         xlims=c(-1.39531265058232,-1.39531265017622),
         xlims=c(0.360240420222429,0.360240420452501), # close to https://www.youtube.com/watch?v=pCpLWbHVNhk
         xlims=c(0.360240420289852,0.360240420290878),
         xlims=c(-1.74999841099374-5E-14,-1.74999841099374+5E-14)+5E-13, # close to https://www.youtube.com/watch?v=zXTpASSd9xE&t=1s
         c(0.360240443437614363236125244449545308482607807-1E-20,0.360240443437614363236125244449545308482607807+1E-20)) # close to https://www.youtube.com/watch?v=pCpLWbHVNhk

y = list(ylims=c(0.10086220543088,0.10086220543102),
         ylims = c(0.065053, 0.065103),
         ylims = c(0.59154553072585,0.59154554095094),
         ylims=c(-0.65207264826579,-0.65207264623937),
         ylims=c(0.62553682276813,0.62553682276825),
         ylims=c(-0.60086512632271,-0.60086512621182),
         ylims=c(-0.24114758845057,-0.24114758845023),
         ylims=c(-1.48843098340569e-08,1.49180707293249e-08),
         ylims=c(0.29981877588193,0.29981877945504),
         ylims=c(0.58549696897045,0.58549696897146),
         ylims=c(0.061562474436316,0.0615624744391),
         ylims=c(-0.60805517438862,-0.60805517438595),
         ylims=c(0.089109539985339,0.089109539985883),
         ylims=c(0.58330139353672,0.58330139353724),
         ylims=c(0.23497573912032,0.23497573912128),
         ylims=c(0.044190272396513,0.044190286611419),
         
         # ylims=c(0.353301929814301,0.353301929815208), # some points from https://math.hws.edu/eck/js/mandelbrot/java/MandelbrotSettings/index.html
         ylims=c(0.363569145553836,0.363569148665212),
         ylims=c(3.98721674447108E-05,3.98721684819073E-05),
         ylims=c(0.0162575663053561,0.0162575663941413),
         ylims=c(-4.24013372E-14,4.32475348E-14),
         ylims=c(0.119141784369707,0.119141784370102),
         ylims=c(0.223484686427229,0.223484686430987),
         ylims=c(0.28959516107179,0.289595161075437),
         ylims=c(0.0439539338605482,0.0439539338608069),
         ylims=c(4.71656188739187E-05,4.71656332806971E-05),
         ylims=c(0.00343688521332044,0.00343688589564389),
         ylims=c(6.01081676973231E-06,6.01102433369534E-06),
         ylims=c(0.155101186849595,0.155101188986986),
         ylims=c(0.385222453175673,0.385222453176056),
         ylims=c(0.000236035955967299,0.000236035960487855),
         ylims=c(0.620186709961487,0.620186709965179),
         ylims=c(0.48240527212169,0.482405276123991),
         # ylims=c(0.000261039117540805,0.000261039123294094),
         ylims=c(4.51656002678696E-07,4.51657128549296E-07),
         ylims=c(0.000644945781574434,0.0006449464089314),
         ylims=c(0.837825971685481,0.83782597168669),
         ylims=c(0.255522662907767,0.255522662908376),
         ylims=c(0.181125362213845,0.181125362213935),
         ylims=c(1.24343609023217E-05,1.24343664933159E-05),
         ylims=c(0.00064302182350296,0.000643024514855936),
         ylims=c(0.000512492900741719,0.000512519415246536),
         ylims=c(3.86839621906898E-09,3.87700069163298E-09),
         ylims=c(6.61090216333227E-05,6.61090217951418E-05),
         ylims=c(-0.113067850721661,-0.113017882459942),
         ylims=c(0.668347222418276,0.668347222496156),
         ylims=c(-2.23773944920555E-05,-2.23759812507002E-05),
         ylims=c(0.000133023124640116,0.000133145283006001),
         ylims=c(0.00861696703453917,0.00861696703751072),
         ylims=c(-1.03669995445733,-1.03669995444011),
         ylims=c(-0.000191815779050361,-0.000191810946444754),
         ylims=c(0.00590565471700737,0.00590565474352945),
         ylims=c(0.595859541361479,0.59585954178498),
         ylims=c(0.0115374859759236,0.0115374860123034),
         ylims=c(-1.78178804785142E-06,-1.7817876141983E-06),
         ylims=c(0.310924917094274,0.310924917099099),
         ylims=c(0.020152732376612,0.0201527324800653),
         ylims=c(0.0846794087369283,0.0846794087374285),
         ylims=c(5.2506598329017E-08,5.2687855506301E-08),
         ylims=c(0.465703143530031,0.465703143542785),
         # ylims=c(0.894818654785476,0.894818654901096),
         ylims=c(0.251642462421845,0.251642462426152),
         ylims=c(0.166143987504656,0.166143989491985),
         ylims=c(0.230995969751777,0.230995970502752),
         ylims=c(-1.122563919E-13,1.113412085E-13),
         ylims=c(0.341620140573152,0.34162014057331),
         ylims=c(0.000276535322597249,0.00027654195589803),
         ylims=c(0.0179460471861493,0.0179460471865173),
         ylims=c(0.520520552304488,0.520520609772238),
         ylims=c(0.000448245889072639,0.000448245890297611),
         ylims=c(0.00102671869615885,0.00102685911803385),
         ylims=c(0.0182162319482242,0.0182162322528061),
         ylims=c(0.64131307967709,0.64131307983637),
         ylims=c(0.64131307974935,0.64131307975006),
         ylims=c(-1.65712469295418E-15-5E-14,-1.65712469295418E-15+5E-14),
         ylims=c(-0.64131306106480317486037501517930206657949495-1E-20,-0.64131306106480317486037501517930206657949495+1E-20)
         
)

# a list of 13 Christmas songs (WAV files from https://www.thewavsite.com/)
songs = list(wav=system.file("audio", "Feliz Navidad - Jose Feliciano.wav", package = "mandelExplorer"),
            wav=system.file("audio", "We Wish You A Merry Christmas - The Chipmunks.wav", package = "mandelExplorer"),
            wav=system.file("audio", "We Wish You A Merry Christmas - Smurfs.wav", package = "mandelExplorer"),
            wav=system.file("audio", "We Wish You a Merry Christmas - Sesame Street.wav", package = "mandelExplorer"),
            wav=system.file("audio", "Jingle Bells - Winnie the Pooh.wav", package = "mandelExplorer"),
            wav=system.file("audio", "Jingle Bells (techno).wav", package = "mandelExplorer"),
            wav=system.file("audio", "All I Want for Christmas for Is You - Mariah Carey.wav", package = "mandelExplorer"),
            wav=system.file("audio", "Do They Know It's Christmas - Band Aid.wav", package = "mandelExplorer"),
            wav=system.file("audio", "Happy Christmas (The War is Over) - John Lennon.wav", package = "mandelExplorer"),
            wav=system.file("audio", "Last Christmas - Wham.wav", package = "mandelExplorer"),
            wav=system.file("audio", "Auld Lang Syne - Scottish bagpipes.wav", package = "mandelExplorer"),
            wav=system.file("audio", "Here Comes Santa Claus - Elvis.wav", package = "mandelExplorer"),
            wav=system.file("audio", "Rockin Around the Christmas Tree - Brenda Lee.wav", package = "mandelExplorer"))

# 96 preset options for Christmas cards with various selections of songs
# 1 to 7 have a reddish Christmas palette, 8 to 14 have a more icey snowflakey look 
# and 15 and 16 are more colourful psychedelic options
# in  addition, there is
# presets 17-32: 16 colourful presets with pal=3=Rainbow with gamma=1.5 & random songs
# presets 33-64: 32 reddish presets with pal=1=Lava with gamma=0.1 & random songs
# presets 65-96: 32 blueish  presets with pal=2=Ice with gamma=0.1 & random songs
presets=list(list(xlims=x[[1]], ylims=y[[1]], pal=1, gamma=1/8, wav=songs[[1]]),
            list(xlims=x[[14]], ylims=y[[14]], pal=1, gamma=1/20, wav=songs[[2]]),
            list(xlims=x[[15]], ylims=y[[15]], pal=1, gamma=1/20, wav=songs[[7]]),
            list(xlims=x[[16]], ylims=y[[16]], pal=1, gamma=1/20, wav=songs[[8]]),
            list(xlims=x[[9]], ylims=y[[9]], pal=4, gamma=1/20, wav=songs[[9]]),
            list(xlims=x[[10]], ylims=y[[10]], pal=4, gamma=1/20, wav=songs[[10]]),
            list(xlims=x[[11]], ylims=y[[11]], pal=4, gamma=1/20, wav=songs[[12]]),
            
            list(xlims=x[[4]], ylims=y[[4]], pal=2, gamma=1/15, wav=songs[[2]]),
            list(xlims=x[[2]], ylims=y[[2]], pal=2, gamma=1/15, wav=songs[[7]]),
            list(xlims=x[[3]], ylims=y[[3]], pal=2, gamma=1/15, wav=songs[[5]]),
            list(xlims=x[[5]], ylims=y[[5]], pal=2, gamma=1/15, wav=songs[[6]]),
            list(xlims=x[[6]], ylims=y[[6]], pal=2, gamma=1/15, wav=songs[[8]]),
            list(xlims=x[[7]], ylims=y[[7]], pal=2, gamma=1/15, wav=songs[[1]]),
            list(xlims=x[[12]], ylims=y[[12]], pal=2, gamma=1/20, wav=songs[[1]]),
            
            list(xlims=x[[8]], ylims=y[[8]], pal=3, gamma=1/10, wav=songs[[1]]),
            list(xlims=x[[13]], ylims=y[[13]], pal=3, gamma=1/8, wav=songs[[6]]),
            
            # presets 17-32: 16 colourful presets with pal=3=Rainbow with gamma=1.5 & random songs
            list(xlims=x[[1]], ylims=y[[1]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[13]], ylims=y[[13]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[18]], ylims=y[[18]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[23]], ylims=y[[23]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[29]], ylims=y[[29]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[38]], ylims=y[[38]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[43]], ylims=y[[43]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[44]], ylims=y[[44]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[57]], ylims=y[[57]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[62]], ylims=y[[62]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[64]], ylims=y[[64]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[66]], ylims=y[[66]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[67]], ylims=y[[67]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[68]], ylims=y[[68]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[72]], ylims=y[[72]], pal=3, gamma=1.5, wav="random"),
            list(xlims=x[[73]], ylims=y[[73]], pal=3, gamma=1.5, wav="random"),
            
            # presets 33-64: 32 reddish presets with pal=1=Lava with gamma=0.1 & random songs
            list(xlims=x[[1]], ylims=y[[1]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[17]], ylims=y[[17]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[19]], ylims=y[[19]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[20]], ylims=y[[20]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[21]], ylims=y[[21]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[22]], ylims=y[[22]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[23]], ylims=y[[23]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[25]], ylims=y[[25]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[27]], ylims=y[[27]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[28]], ylims=y[[28]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[31]], ylims=y[[31]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[32]], ylims=y[[32]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[33]], ylims=y[[33]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[34]], ylims=y[[34]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[38]], ylims=y[[38]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[39]], ylims=y[[39]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[40]], ylims=y[[40]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[45]], ylims=y[[45]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[51]], ylims=y[[51]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[52]], ylims=y[[52]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[53]], ylims=y[[53]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[54]], ylims=y[[54]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[56]], ylims=y[[56]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[57]], ylims=y[[57]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[58]], ylims=y[[58]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[61]], ylims=y[[61]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[62]], ylims=y[[62]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[66]], ylims=y[[66]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[67]], ylims=y[[67]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[69]], ylims=y[[69]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[71]], ylims=y[[71]], pal=1, gamma=0.1, wav="random"),
            list(xlims=x[[73]], ylims=y[[73]], pal=1, gamma=0.1, wav="random"),
            
            # presets 65-96: 32 blueish  presets with pal=2=Ice with gamma=0.1 & random songs
            list(xlims=x[[2]], ylims=y[[2]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[3]], ylims=y[[3]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[4]], ylims=y[[4]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[5]], ylims=y[[5]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[6]], ylims=y[[6]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[7]], ylims=y[[7]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[12]], ylims=y[[12]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[13]], ylims=y[[13]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[14]], ylims=y[[14]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[15]], ylims=y[[15]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[17]], ylims=y[[17]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[20]], ylims=y[[20]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[21]], ylims=y[[21]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[22]], ylims=y[[22]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[23]], ylims=y[[23]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[25]], ylims=y[[25]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[28]], ylims=y[[28]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[31]], ylims=y[[31]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[38]], ylims=y[[38]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[39]], ylims=y[[39]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[40]], ylims=y[[40]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[50]], ylims=y[[50]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[51]], ylims=y[[51]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[52]], ylims=y[[52]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[54]], ylims=y[[54]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[56]], ylims=y[[56]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[57]], ylims=y[[57]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[58]], ylims=y[[58]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[62]], ylims=y[[62]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[66]], ylims=y[[66]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[67]], ylims=y[[67]], pal=2, gamma=0.1, wav="random"),
            list(xlims=x[[71]], ylims=y[[71]], pal=2, gamma=0.1, wav="random")
             )


## COUPLE OF UTILITY FUNCTIONS

# auto setting for nr of iterations
nrofiterations = function (xlims) min(round(500+log10(((4/abs(diff(xlims)))))^5),1E4) # attempt at setting sensible nr of iterations based on zoom level

# scale vector between 0 and 1
range01 <- function(x){(x - min(x)) / (max(x) - min(x))}

# function to equalize vector y
.equalize = function(y, rng= c(0, 0.90), levels = 256, breaks) {
  h = tabulate(findInterval(y, vec=breaks)) 
  cdf = cumsum(h)
  cdf_min = min(cdf[cdf>0])
  
  equalized = ( (cdf - cdf_min) / (prod(dim(y)) - cdf_min) * (rng[2L] - rng[1L]) ) + rng[1L]
  bins = round( (y - rng[1L]) / (rng[2L] - rng[1L]) * (levels-1L) ) + 1L
  
  return(equalized[bins])
}

# function to equalize matrix m
equalize <- function(m, rng = c(0, 0.90), levels = 256){
  if (!is.null(dim(m))) { ordims = dim(m); m = as.vector(m) } else { ordims = NULL }
  m = range01(m)*rng[[2L]]
  r = range(m)
  if ( r[1L] != r[2L] ) {
    levels = as.integer(levels)
    breaks = seq(rng[1L], rng[2L], length.out = levels + 1L)
    m = .equalize(m, rng, levels, breaks) 
    m = range01(m)*rng[[2L]]
    if (!is.null(ordims)) dim(m) = ordims
  }
  return(m)
}

# function to equalize all values that are not in the M-set - works but a bit slow
equalizeman <- function(m, nb_iter, rng = c(0, 0.90), levels = 256) {
  if (!is.null(dim(m))) { ordims = dim(m); m = as.vector(m) } else { ordims = NULL }
  inmandel = (m==nb_iter)
  m[!inmandel] = equalize(m[!inmandel], rng, levels)
  m[inmandel] = 1
  if (!is.null(ordims)) dim(m) = ordims
  return(m)
}

# estimate adaptive gamma value so that median of 0-1 scaled intensity values becomes = intens - fast but doesn't always work
adgamma = function (m, nb_iter, subsamp=10, intens=0.4) { 
  subs_rows=seq(1,nrow(m),length.out=round(nrow(m)/subsamp))
  subs_cols=seq(1,ncol(m),length.out=round(nrow(m)/subsamp))
  subsm=as.vector(m[subs_rows,subs_cols])
  subsm=subsm/nb_iter
  subsm_notinM=subsm[subsm!=1]
  #hist(subsm_notinM)
  adgamma = -log(1/intens)/log(median(subsm_notinM)) # ensures that median of 0-1 scaled values will become = intens
  return(adgamma)
}

# function to convert matrix to hex colour raster
mat2rast = function(mat, col) {
  idx = findInterval(mat, seq(0, 1, length.out = length(col)))
  colors = col[idx]
  rastmat = t(matrix(colors, ncol = ncol(mat), nrow = nrow(mat), byrow = TRUE))
  class(rastmat) = "raster"
  return(rastmat)
}

# function to convert matrix to nativeRaster given a colour palette col
mat2natrast = function(mat, col) {
  idx = findInterval(mat, seq(0, 1, length.out = length(col)))
  colors = col[idx]
  natrast = nara::raster_to_nr(t(matrix(colors, ncol = ncol(mat), nrow = nrow(mat), byrow = TRUE)))
  return(natrast)
}

# alt function to convert matrix to nativeRaster
# this was somehow slower than function above
mat2natrast2 = function(mat, col) {
  idx = findInterval(mat, seq(0, 1, length.out = length(col)))
  colints = farver::encode_native(col[idx]) # hex colours as integers representing RGBA
  # colints = nara::colour_to_integer(col[idx]) # this would be 2x slower still
  natrast = t(matrix(colints, ncol = ncol(mat), nrow = nrow(mat), byrow = TRUE))
  class(natrast) = "nativeRaster"
  return(natrast)
}
