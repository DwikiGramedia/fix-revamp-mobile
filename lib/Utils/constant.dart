const String r1 = "~#%&";
const String r2 = "*&#@!";
const String r3 = "&%^)";

const String saltEpub = "4d0470542b1e034b3386dd19236189ff";
const String saltLastEpub = "santiang";

const String zipSalt = "!@#\$Gnjiolkuy44567890-yHUIkjhtrfgHY&0pl/09876`wdfBNJK";
const String pdfSalt =
    "pou56^YHNyfvbn@#\$%^YJM./-[)12efvb%tgHJkL@#RghjI()P:?!][98yh";

const METHOD_READER_CHANNEL = "new_eperpus/reader";
const METHOD_READER_PDF = "getColibrioReader";
const METHOD_READER_EPUB = "getColibrioReaderEPub";
const METHOD_DOWNLOAD = "new_eperpus/download";

enum ResException {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  badCertificate,
  badResponse,
  cancel,
  connectionError,
  unknown,
}
