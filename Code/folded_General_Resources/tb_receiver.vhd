library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.system_constants.all;

entity tb_receiver is
end tb_receiver;

architecture test of tb_receiver is

component Simeck32_64_receiver is
port 
	(
  		clk	    : in std_logic;
		clk_Simeck  : in std_logic;
		rst	    : in std_logic;
		data_stream : in std_logic;
		I	    : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		Q           : in std_logic_vector((DATAPATH_SIZE-1) downto 0);
		symbol      : out std_logic_vector((SYMBOL_SIZE-1) downto 0)  		
	);

end component Simeck32_64_receiver;
    
signal clk, clk_Simeck, rst : std_logic;
signal data_stream : std_logic := '0';
    
signal I : std_logic_vector((DATAPATH_SIZE-1) downto 0):=(others=>'0');
signal Q : std_logic_vector((DATAPATH_SIZE-1) downto 0):=(others=>'0');
signal symbol : std_logic_vector((SYMBOL_SIZE-1) downto 0);
    
constant CLOCK_PERIOD : time := 64 ns;

type arr is array(integer range <>) of std_logic_vector((DATAPATH_SIZE-1) downto 0);    

constant CHECK_CASES : integer := 1000;
    
constant I_check: arr(0 to CHECK_CASES-1)  := (
x"B44A",x"F7D7",x"6301",x"6460",x"0106",x"06BB",x"0ECA",x"6DA2",x"A41B",x"AF43",x"764C",x"84A8",x"FA92",x"B9E3",x"CE3A",x"D1B1",x"1609",x"24FD",x"3E60",x"43CB",x"F849",x"B3CA",x"C5FF",x"DCFF",x"1BDC",x"415C",x"843D",x"1496",
x"1A38",x"91E8",x"1C10",x"2E17",x"5E11",x"D3DF",x"3147",x"DAEC",x"DB34",x"A254",x"6881",x"97B9",x"2B3A",x"3C4E",x"B92F",x"D59D",x"E90C",x"C48B",x"BD50",x"3ED2",x"DD5C",x"7052",x"1368",x"AACA",x"EE5A",x"4FCA",x"FAAD",x"C5AB",
x"1F42",x"C1F7",x"677B",x"B4DD",x"417D",x"658B",x"9208",x"FF33",x"CBD4",x"C590",x"8F1A",x"AC80",x"2775",x"9D1D",x"F5C9",x"4C70",x"47F1",x"110F",x"664E",x"4087",x"DE2E",x"03BB",x"DC43",x"8337",x"BC7B",x"D703",x"263A",x"1DDD",
x"0C23",x"8B8F",x"DB51",x"C3D0",x"FBB4",x"BA90",x"DC8D",x"1D89",x"043D",x"EEEE",x"8AFF",x"DAA5",x"53A9",x"4823",x"5D1A",x"FB5B",x"5E7B",x"41CA",x"DD2B",x"40C6",x"0AE6",x"F486",x"7647",x"CD3E",x"B2BA",x"524C",x"C5DE",x"7E7E",
x"5DFE",x"4B97",x"DA92",x"D9B0",x"3887",x"4B76",x"8AA2",x"E3D6",x"E916",x"404C",x"B2C4",x"DCB9",x"BB86",x"CDEA",x"D74C",x"53B2",x"5C51",x"26F1",x"F177",x"234B",x"C156",x"A703",x"AF26",x"5635",x"11A3",x"CBDC",x"838F",x"3BA3",
x"8E11",x"9B29",x"8021",x"26DD",x"82E6",x"DC2E",x"B2B8",x"0490",x"3F9A",x"1292",x"2D3A",x"73F4",x"A2E2",x"24DB",x"C629",x"1320",x"B12D",x"0E51",x"570E",x"34F5",x"4819",x"A81C",x"4570",x"7C19",x"4790",x"90D4",x"DFE4",x"C841",
x"B6BC",x"8F36",x"F2AD",x"81DB",x"CC27",x"595F",x"0EE0",x"6592",x"5EED",x"75F2",x"ED08",x"4998",x"2234",x"541A",x"A4EF",x"559A",x"7B2D",x"4E34",x"0AC9",x"B9C7",x"99E8",x"8ACB",x"84BD",x"FA47",x"D52C",x"81C6",x"35DE",x"AE5B",
x"E960",x"F590",x"BC61",x"7E8F",x"4BDB",x"8B09",x"2204",x"5E60",x"A928",x"0A61",x"7B9B",x"35E7",x"ABD1",x"E44E",x"8698",x"65C2",x"DD1D",x"0EB1",x"BAAF",x"A16C",x"815A",x"4C17",x"A93A",x"635B",x"8B5B",x"7FD7",x"BFF1",x"CDDC",
x"A1BB",x"FF7F",x"BED9",x"BD25",x"9700",x"0F8E",x"F013",x"1BB3",x"F648",x"B2D5",x"8AE9",x"F129",x"9F78",x"69B4",x"62CF",x"A277",x"4B07",x"7C15",x"6D27",x"D337",x"DF5D",x"D519",x"A145",x"7456",x"F3EB",x"65E3",x"650B",x"D45E",
x"6879",x"B23D",x"F7B1",x"7D30",x"B58D",x"419C",x"C814",x"69AE",x"309E",x"68DA",x"526B",x"572B",x"E0E3",x"44B7",x"090F",x"1C36",x"06F2",x"D893",x"43C2",x"C73B",x"BE56",x"6DEF",x"76EA",x"95BE",x"3342",x"547C",x"ADB9",x"1C03",
x"2BA9",x"6FA5",x"557B",x"2C2E",x"4DAF",x"0724",x"315C",x"ADC5",x"19AD",x"2C09",x"EE57",x"A0BD",x"C12E",x"97EF",x"1178",x"454C",x"4149",x"FCBC",x"96FF",x"CE74",x"DC5C",x"16E8",x"7E95",x"7B92",x"96E6",x"CBD2",x"D458",x"EAF8",
x"214E",x"B3DA",x"29CC",x"516A",x"8AE8",x"E159",x"DF75",x"F79C",x"861D",x"39A2",x"1D2E",x"DAF3",x"DF59",x"7E19",x"6327",x"785A",x"54A4",x"90D9",x"810B",x"C5D5",x"CCC3",x"D2E8",x"40BA",x"BA91",x"DEC8",x"D460",x"E48F",x"8927",
x"B411",x"31EA",x"81E7",x"7D0E",x"0469",x"6924",x"CC62",x"E700",x"D539",x"5ED9",x"139B",x"A86C",x"2696",x"7451",x"71C7",x"9289",x"1080",x"EDDB",x"648A",x"3B15",x"6BC4",x"7881",x"0D44",x"0E41",x"A5CA",x"49A9",x"288F",x"7F48",
x"F6DA",x"78A4",x"DFEB",x"869D",x"25CA",x"D265",x"A91B",x"7014",x"0DEA",x"E1C9",x"AC1A",x"1FC4",x"49DD",x"610E",x"E4BC",x"5C9E",x"AB06",x"D765",x"0148",x"E7A8",x"9339",x"40C3",x"D9ED",x"C909",x"4FE3",x"635F",x"8779",x"8A91",
x"C41F",x"57A4",x"198E",x"B184",x"36A3",x"A6F7",x"01EF",x"DCA1",x"022C",x"E56A",x"A2D9",x"3EF5",x"99AF",x"2CA0",x"9D28",x"5CF8",x"3C46",x"004D",x"3072",x"0F3C",x"F88D",x"BD8E",x"E755",x"398A",x"F104",x"47B5",x"1A00",x"BE21",
x"0145",x"971B",x"254F",x"0900",x"9F6D",x"888B",x"DC60",x"58A7",x"5DF8",x"1EB4",x"18B8",x"71AD",x"E915",x"7082",x"CB14",x"7AA6",x"9731",x"4FBD",x"64F7",x"FC4E",x"4788",x"1B71",x"23D9",x"1A8E",x"C74C",x"DDA2",x"57EF",x"6919",
x"38A6",x"924A",x"DD79",x"B326",x"A090",x"7B8A",x"FEC3",x"F339",x"8724",x"756E",x"AB56",x"AD0F",x"F787",x"DA7F",x"6226",x"12DA",x"CD2A",x"F1D9",x"A9FB",x"46C0",x"3BE1",x"7757",x"82B1",x"971E",x"6FD2",x"D2C2",x"20D9",x"737F",
x"6D52",x"D276",x"E83A",x"85D4",x"9507",x"1B76",x"C404",x"E8C2",x"C4A7",x"A20F",x"30D6",x"014C",x"4E15",x"3C86",x"986C",x"635C",x"ADD9",x"1F5E",x"C16F",x"ECD8",x"93F8",x"B614",x"E3FF",x"B4B3",x"132C",x"F579",x"3C42",x"6285",
x"AE1B",x"C09F",x"A6F2",x"34B2",x"2CB0",x"A079",x"C307",x"8A51",x"EC0C",x"0A91",x"C75B",x"1544",x"7214",x"621D",x"3887",x"8110",x"1AED",x"CDC1",x"6A72",x"C06B",x"6B46",x"C8E7",x"4406",x"73BD",x"504A",x"1C9D",x"3160",x"569E",
x"025D",x"5B18",x"51C8",x"EB72",x"FCEE",x"66B8",x"E269",x"1729",x"12C1",x"2E3D",x"6AC2",x"A379",x"A0AF",x"F101",x"827B",x"C8F4",x"30EE",x"8D9C",x"DDEB",x"2434",x"01F5",x"0810",x"949A",x"1ED5",x"85E1",x"2B3B",x"BF4E",x"42D8",
x"7375",x"DEA5",x"DF81",x"FDC5",x"6901",x"3F22",x"F5BA",x"4F70",x"E38A",x"F22A",x"03F5",x"E29D",x"E669",x"8D4D",x"3DD8",x"3E1D",x"C90A",x"1694",x"9AA2",x"0125",x"4A9F",x"7991",x"8CFF",x"92E4",x"7DAB",x"AB40",x"47BF",x"8285",
x"4E5C",x"856F",x"95C0",x"0163",x"5D5E",x"AC46",x"DECA",x"D759",x"C6DF",x"63C5",x"A612",x"1371",x"C267",x"61BA",x"18BB",x"9463",x"EA7E",x"4E3B",x"D703",x"EFF2",x"6DE8",x"2389",x"DE0C",x"DA5C",x"DE5C",x"6681",x"852E",x"894A",
x"3184",x"FB06",x"C569",x"DDDE",x"7800",x"503C",x"58C0",x"0E7E",x"B450",x"3F92",x"27B0",x"B71E",x"732C",x"E26C",x"2CDB",x"3810",x"0CA5",x"D8BD",x"0876",x"67DC",x"663A",x"FF8F",x"0C52",x"6A58",x"1D68",x"A40F",x"F079",x"32C6",
x"612A",x"D55C",x"2D6A",x"9BB1",x"2736",x"F770",x"EBB2",x"4733",x"3B04",x"A37A",x"F271",x"E5ED",x"F156",x"1D41",x"7979",x"6F66",x"00B7",x"2841",x"26A0",x"D797",x"4F7D",x"6F08",x"6B21",x"A144",x"E6D4",x"6D87",x"E392",x"3F2A",
x"300C",x"20F9",x"B848",x"87C8",x"5E4B",x"D79C",x"F6C4",x"D534",x"B65C",x"76D7",x"05EA",x"F2B2",x"2455",x"0D5F",x"92D8",x"D52D",x"4676",x"3E10",x"0712",x"A36D",x"B10C",x"9A8E",x"7166",x"3EC4",x"9EE9",x"6C69",x"69FD",x"2D79",
x"31D2",x"38FE",x"B6EB",x"72A9",x"2B4F",x"A42B",x"EA92",x"85DC",x"B777",x"65FC",x"06E0",x"9909",x"C790",x"C466",x"416B",x"182F",x"E2B9",x"BA04",x"D7EF",x"9704",x"535F",x"7DFD",x"993A",x"6D5C",x"6F74",x"5312",x"A8C1",x"5CE3",
x"EBD0",x"8D8F",x"2AF6",x"6E67",x"4D1F",x"DD67",x"ED21",x"33B5",x"3356",x"EF79",x"A6DC",x"49ED",x"E296",x"B0DB",x"9CED",x"3301",x"A034",x"7E1E",x"5219",x"5D62",x"38BB",x"63D7",x"FDFA",x"E14C",x"A146",x"CEB4",x"139E",x"9DAA",
x"361D",x"B025",x"8A41",x"07F8",x"46AE",x"D4D0",x"C088",x"0589",x"1788",x"1525",x"C55A",x"BAD2",x"DD0D",x"CFD9",x"43CD",x"0DAF",x"1D89",x"066D",x"AA87",x"0794",x"5A35",x"6A3A",x"851F",x"E748",x"DB44",x"0E23",x"9AAE",x"F8A5",
x"CBD5",x"DA1E",x"87D0",x"B8A0",x"B5C5",x"A88F",x"A911",x"E820",x"D22F",x"3344",x"0B55",x"BFCA",x"233B",x"C0AC",x"8B68",x"6CD7",x"789B",x"E89D",x"8350",x"ED8B",x"639B",x"BE59",x"2E9E",x"6DA9",x"16EC",x"5724",x"166A",x"5036",
x"79A8",x"89B0",x"C1C2",x"43D7",x"DA5F",x"5255",x"AAB1",x"5191",x"480D",x"90C7",x"E722",x"28D4",x"C789",x"C86E",x"972B",x"2420",x"B552",x"0785",x"BDF7",x"EF25",x"D01A",x"70B5",x"FAFA",x"80A2",x"D86E",x"F289",x"2B40",x"19B4",
x"69C7",x"98D1",x"A536",x"5CFF",x"33D1",x"CF48",x"F0FA",x"9706",x"3F9F",x"5F81",x"69D7",x"FFFF",x"9C02",x"16FF",x"FD52",x"5C8B",x"15A7",x"C633",x"C79D",x"2CF4",x"5C99",x"A39A",x"02D5",x"9D26",x"1379",x"0F56",x"EE83",x"4B22",
x"5E04",x"F4BF",x"2536",x"CC51",x"24FC",x"54F4",x"4A69",x"58C7",x"7D19",x"FA6C",x"1E56",x"A560",x"6723",x"E662",x"C054",x"34AF",x"F208",x"CEE6",x"E463",x"C634",x"267F",x"54D8",x"7BDE",x"6D13",x"B0A7",x"839F",x"24B1",x"59FF",
x"EA51",x"A5D6",x"0199",x"F7E5",x"F8BB",x"99E9",x"F9DB",x"938C",x"BD0D",x"3C34",x"69D9",x"E2CA",x"0526",x"095E",x"746D",x"94BC",x"5974",x"B552",x"490E",x"CB28",x"AFE3",x"E2E3",x"5E4B",x"F36F",x"3942",x"263A",x"4AD2",x"DCFD",
x"BB37",x"C99C",x"24DE",x"3E2A",x"3943",x"0C57",x"4354",x"D336",x"728B",x"052E",x"8F14",x"7B10",x"F829",x"B6B8",x"F712",x"9795",x"77BF",x"5D15",x"7AA8",x"5B27",x"CA4C",x"9EFA",x"7195",x"BEFA",x"293E",x"C941",x"C26E",x"EC1D",
x"EFBD",x"B2F8",x"DE32",x"94EC",x"2405",x"95DC",x"792C",x"54C1",x"AF91",x"F199",x"0599",x"393F",x"8034",x"E1A5",x"227D",x"F2C5",x"BC90",x"28F3",x"D16F",x"AEF3",x"10AF",x"D3BC",x"48BA",x"0E47",x"989B",x"6855",x"A8B4",x"C0F2",
x"D8E5",x"D846",x"D0D8",x"8476",x"A5E9",x"A74E",x"E0FF",x"E4B0",x"AF99",x"8C0C",x"9360",x"B07B",x"71A9",x"8B3F",x"86E8",x"07AF",x"F34B",x"366D",x"8371",x"A986"
);

constant Q_check: arr(0 to CHECK_CASES-1)  := (
x"AA79",x"FB43",x"F7D3",x"CC83",x"5E6B",x"57BE",x"1944",x"1D3E",x"B3E4",x"FDD6",x"BC24",x"ED71",x"1D94",x"5205",x"5EA8",x"1602",x"644A",x"0849",x"D820",x"B4D8",x"BF5F",x"AC3A",x"0CA6",x"3DFA",x"62AC",x"B7BC",x"DB15",x"627C",
x"D78A",x"7C4E",x"E68C",x"32E4",x"2B2C",x"0028",x"CA42",x"FA86",x"9C35",x"761B",x"89DE",x"9FAB",x"4FD6",x"731A",x"808C",x"B702",x"314C",x"50D2",x"12AD",x"318A",x"D908",x"05CA",x"3FDD",x"5DC6",x"AA6D",x"3757",x"1262",x"A36B",
x"8707",x"5D46",x"254B",x"EE74",x"90E9",x"FE03",x"D44D",x"627E",x"9896",x"E583",x"F7D1",x"E43B",x"AA81",x"A8B4",x"2C08",x"6A4D",x"03E2",x"0FB2",x"271D",x"3778",x"5A6F",x"E97B",x"CC3A",x"F766",x"2483",x"9BD5",x"7ECA",x"E6DE",
x"E32F",x"97A0",x"010B",x"4232",x"CC6C",x"28B2",x"6DD5",x"E037",x"0BE5",x"CC6D",x"EE9E",x"1F57",x"AADB",x"E5C0",x"5AE0",x"DC13",x"BE08",x"EAF7",x"E64A",x"380B",x"5887",x"749E",x"8623",x"43F7",x"DF00",x"CD60",x"A0E9",x"7B73",
x"F760",x"0AD9",x"5805",x"9938",x"ADB8",x"E275",x"02EC",x"93C3",x"C535",x"76F5",x"ADBD",x"AE6D",x"3246",x"8EBA",x"72AA",x"F51A",x"66AD",x"543F",x"D41F",x"9496",x"D7DB",x"01DF",x"1043",x"0C39",x"371A",x"9D93",x"0D8B",x"DD71",
x"DD78",x"B673",x"BA90",x"76A1",x"1DC4",x"0312",x"E4EA",x"AF6D",x"FFE8",x"6EF0",x"C890",x"8806",x"8901",x"63ED",x"3389",x"6CA3",x"8222",x"3CD4",x"8B45",x"DEDA",x"A3AB",x"DF7E",x"FF56",x"961E",x"6A8B",x"25B7",x"8FDB",x"55ED",
x"7EBF",x"2BF9",x"985A",x"F0C6",x"4F59",x"1FB9",x"9D01",x"D206",x"45C3",x"8865",x"8EE5",x"A91A",x"A8A7",x"0240",x"4BA3",x"97C6",x"A200",x"3ACA",x"AB00",x"EC43",x"F0BD",x"874E",x"02C5",x"CDBB",x"C6C5",x"AA6F",x"53A0",x"43C4",
x"E291",x"9F82",x"1C36",x"0A48",x"982C",x"D356",x"A47F",x"A70F",x"602E",x"9612",x"9634",x"23CF",x"D383",x"02E3",x"72EC",x"5165",x"799E",x"7A6E",x"B05A",x"13BF",x"4248",x"2878",x"BE86",x"84A6",x"5248",x"C588",x"BDB3",x"68EE",
x"0411",x"3B0B",x"2386",x"6658",x"0525",x"4315",x"364D",x"98FF",x"0CCD",x"6C38",x"6168",x"8A6E",x"1690",x"AA49",x"4640",x"B9EB",x"50E3",x"B1FC",x"E85D",x"BE9B",x"F314",x"586D",x"E262",x"BFD7",x"123C",x"0CB9",x"AA36",x"0EFC",
x"20E7",x"E0A4",x"A4B4",x"11B0",x"01E1",x"65E7",x"0A57",x"14EB",x"4B41",x"7E75",x"590D",x"4905",x"8290",x"EAC9",x"3108",x"1D8D",x"CD25",x"45A0",x"3F10",x"3D5E",x"8A85",x"1209",x"186E",x"EBA1",x"14AB",x"96BB",x"DC7F",x"BF42",
x"02D4",x"5035",x"038C",x"11DD",x"3646",x"623C",x"8500",x"45E4",x"F1A7",x"F0D8",x"AC2A",x"ED2F",x"F1A3",x"3AAE",x"2275",x"E84F",x"1FE5",x"4991",x"4AC6",x"A273",x"6E45",x"823F",x"3871",x"F29D",x"7057",x"5FF3",x"8A43",x"C800",
x"34E3",x"45C6",x"045A",x"CBD5",x"3B87",x"8E47",x"B690",x"3340",x"C6B5",x"35D9",x"A944",x"E8F8",x"93ED",x"4135",x"CC06",x"3AEB",x"525B",x"83A2",x"E9A1",x"F0BF",x"7B84",x"B4D9",x"18D2",x"DB19",x"EDF8",x"5682",x"99B7",x"1DFA",
x"3CA7",x"05E0",x"5B5D",x"7506",x"66FE",x"DAD6",x"59F1",x"B879",x"5055",x"3421",x"32AE",x"D03F",x"FBD4",x"174E",x"5B7F",x"70BA",x"D61D",x"8513",x"001C",x"029A",x"C75F",x"351C",x"33D9",x"89CA",x"559A",x"1B77",x"304C",x"C153",
x"DCB6",x"B5A6",x"FF0C",x"A048",x"01E8",x"F425",x"5F65",x"748A",x"CC50",x"912B",x"20F9",x"4AF1",x"0333",x"0B93",x"96B6",x"CFE9",x"FE66",x"1979",x"6801",x"49D6",x"DF9B",x"BAD6",x"A173",x"BDC6",x"8961",x"4330",x"7079",x"AB2F",
x"245C",x"F6DD",x"6DCD",x"E848",x"D8D2",x"950F",x"313C",x"1F62",x"9610",x"6B9A",x"FC09",x"3D19",x"1403",x"F73C",x"667B",x"D2BF",x"993E",x"B701",x"F221",x"99A1",x"7143",x"05EA",x"338C",x"714A",x"990D",x"9C9A",x"94BE",x"523F",
x"C6DB",x"8583",x"8175",x"AC34",x"EC10",x"925E",x"C678",x"8119",x"D036",x"3052",x"E42F",x"AEAC",x"7FD1",x"D293",x"5481",x"54C1",x"6CFF",x"C748",x"53BE",x"77AB",x"E603",x"A908",x"B1FB",x"F278",x"54AA",x"D8EB",x"6069",x"797C",
x"E9CC",x"1E64",x"E786",x"7319",x"4F6D",x"8864",x"1444",x"078C",x"B569",x"2F80",x"6084",x"C8A8",x"8D9A",x"8606",x"973B",x"B3B8",x"DEE8",x"D4E7",x"8BAB",x"0ECF",x"C6A7",x"45A1",x"6C5E",x"3AD2",x"87E3",x"3E64",x"7671",x"DE91",
x"A5BE",x"3492",x"C579",x"8C41",x"FE54",x"590F",x"7BA0",x"5411",x"20D2",x"37F2",x"EA3E",x"D555",x"729A",x"472E",x"C687",x"82DD",x"A685",x"CAF8",x"E49F",x"9972",x"8307",x"75B0",x"765F",x"50D0",x"B80D",x"DD82",x"DC7B",x"81D2",
x"F795",x"168C",x"806D",x"2BAD",x"20DE",x"D138",x"2316",x"3E10",x"45B4",x"3B8F",x"F3C5",x"0751",x"7E95",x"F631",x"5D40",x"E918",x"D77C",x"3537",x"505B",x"B3F0",x"2A84",x"9AAB",x"69C3",x"F2BB",x"714C",x"D6EC",x"1948",x"FE3C",
x"C73B",x"865A",x"41E8",x"D0E6",x"F6DF",x"3872",x"F7E6",x"4C81",x"CDFC",x"E715",x"B71B",x"65BE",x"C9B4",x"497F",x"9682",x"F8B0",x"C5A1",x"9900",x"2986",x"D0BB",x"B5BC",x"B04C",x"2989",x"8154",x"FA11",x"CFA4",x"C3C8",x"A0DF",
x"3ED9",x"9651",x"95EC",x"4EF1",x"AD3F",x"AC98",x"2B5F",x"4916",x"E1F2",x"DA3B",x"92FF",x"E20F",x"929A",x"56DD",x"8D8A",x"981F",x"C0B7",x"2B96",x"D803",x"3525",x"479B",x"8F05",x"3503",x"E3DF",x"5C45",x"9D00",x"6385",x"A620",
x"CAA3",x"FF26",x"4E42",x"CCAB",x"80F5",x"7D0B",x"DF1A",x"591A",x"5B79",x"587C",x"9AF3",x"37AE",x"F083",x"2C33",x"3348",x"BA29",x"4765",x"B70B",x"25E1",x"462A",x"A51A",x"2FE5",x"EA47",x"3EFE",x"0030",x"14A7",x"B6DF",x"30B0",
x"7FE2",x"970C",x"D2FA",x"CCE1",x"E156",x"95F1",x"C1FF",x"FC40",x"2ED4",x"5FB5",x"1312",x"D1CB",x"9B80",x"5576",x"D73B",x"78E2",x"0B9C",x"83D5",x"160B",x"4FF1",x"9B69",x"3EEB",x"DC3D",x"0439",x"9634",x"26B5",x"688E",x"35E0",
x"586A",x"AA22",x"23B6",x"646B",x"6F76",x"C667",x"CAC5",x"3102",x"453F",x"4DDC",x"64E3",x"173C",x"DCB3",x"B61E",x"1AD1",x"9597",x"7313",x"B6D4",x"439A",x"A535",x"26CC",x"8207",x"A1EE",x"48ED",x"4DE0",x"008B",x"3CF7",x"7000",
x"92D4",x"49AB",x"B65D",x"7BAE",x"1A9F",x"601A",x"56B0",x"63E8",x"3E02",x"12CB",x"36F3",x"CA12",x"EAFF",x"65A8",x"88B1",x"CD2E",x"72FA",x"9AEA",x"43DB",x"CB01",x"935E",x"9822",x"7506",x"EFC7",x"EA71",x"4386",x"1556",x"7EBD",
x"8C9C",x"A315",x"880C",x"7CD8",x"EFBE",x"652B",x"81CA",x"CBC7",x"CC50",x"A0C7",x"62F7",x"7363",x"C820",x"BF80",x"3000",x"C2F7",x"F62D",x"3864",x"9BC4",x"4715",x"83DA",x"56DD",x"85D8",x"47A9",x"3818",x"5B82",x"2FB3",x"0F7F",
x"B847",x"C1FD",x"7D26",x"A644",x"4C6D",x"2382",x"A454",x"1CF3",x"32B4",x"303C",x"CC58",x"7E00",x"8D91",x"3621",x"FCCC",x"2441",x"AA3A",x"237D",x"445A",x"5D5E",x"6610",x"39A5",x"E942",x"6B5B",x"6C78",x"1776",x"313B",x"99E4",
x"A95F",x"FE4D",x"37A9",x"F7B1",x"9BB9",x"D03B",x"1150",x"A485",x"40EA",x"0FB3",x"680D",x"3023",x"D85B",x"AD01",x"1BB5",x"76BE",x"6DF0",x"1B57",x"B5CA",x"CD0B",x"EAEF",x"6E77",x"70B6",x"5335",x"000B",x"8965",x"85F4",x"32DE",
x"7FA4",x"2737",x"264E",x"DAA0",x"EE43",x"97AA",x"99B1",x"1684",x"CD75",x"6F99",x"9352",x"A1D1",x"EB0E",x"C1BC",x"8BEE",x"6F62",x"BBB5",x"696E",x"4D40",x"09CA",x"9CC9",x"CA16",x"75DD",x"1F93",x"6E3A",x"76A8",x"8BF8",x"79A1",
x"C8B4",x"4A5C",x"F782",x"226A",x"2946",x"B7EB",x"0165",x"ED29",x"66B1",x"A78F",x"2A4D",x"EBE4",x"E66D",x"D42B",x"6E39",x"1F49",x"90FF",x"9258",x"1F86",x"5CB9",x"8085",x"2A79",x"8744",x"2C14",x"AD04",x"B4CB",x"24B8",x"CBBB",
x"8C50",x"82D5",x"A74E",x"40DE",x"E7A5",x"EB0E",x"07B3",x"2E1E",x"5D0F",x"5831",x"1F25",x"1840",x"F383",x"164F",x"BC0B",x"79B5",x"97F3",x"6B65",x"5837",x"24AE",x"6F2C",x"2989",x"A545",x"5310",x"5BE4",x"8F69",x"921A",x"DCD8",
x"92C7",x"0AB1",x"D12E",x"2F35",x"E8FE",x"87CB",x"AC1D",x"4CA8",x"DA76",x"5D35",x"2B2D",x"4009",x"3BF2",x"AEE0",x"4725",x"5F4D",x"5B3D",x"6BA1",x"D4A8",x"E8F9",x"E973",x"DC7F",x"5C25",x"1AAB",x"CA96",x"C2BA",x"232C",x"10CF",
x"A4A0",x"B620",x"1062",x"474A",x"8BAD",x"B977",x"4DB1",x"09DA",x"4AAC",x"5C5E",x"92A3",x"8958",x"9350",x"7710",x"30B9",x"F9DB",x"B6A1",x"48AC",x"9F7E",x"6907",x"DB6D",x"46C7",x"1762",x"1DEF",x"0506",x"5886",x"079D",x"957C",
x"6354",x"DF1E",x"BAB5",x"45B9",x"7762",x"05EE",x"A753",x"D475",x"04E1",x"6F55",x"AF44",x"B474",x"865C",x"37F2",x"27D8",x"450D",x"F949",x"B662",x"7F15",x"C4A7",x"D4B1",x"0450",x"08B2",x"A722",x"1D99",x"404D",x"09C0",x"2FD8",
x"0A14",x"4808",x"6183",x"262C",x"2EE3",x"AD78",x"5CF8",x"BF98",x"5B5A",x"C7A9",x"C76C",x"A3A5",x"FD94",x"0560",x"8F51",x"4CD9",x"B78D",x"633C",x"721D",x"206E",x"4B16",x"0045",x"C39D",x"4D8B",x"F58D",x"68A4",x"BD90",x"9F40",
x"972E",x"AB08",x"E440",x"C395",x"2E35",x"FCE1",x"BBCF",x"BA60",x"AA9B",x"2EB8",x"8A5F",x"5F3E",x"D206",x"B8B3",x"42DB",x"C3E7",x"CE11",x"FF8C",x"C96B",x"0C4C"
);

begin

dut: Simeck32_64_receiver
    port map
    (
        clk         => clk,
	clk_Simeck  => clk_Simeck,
        rst         => rst,
        data_stream => data_stream,
        I           => I,
        Q     	    => Q,
	symbol 	    => symbol  
);  
    
tb: process
begin
       
wait until rst = '1';
wait until rst = '0';
   
wait for 75 ns; 
data_stream <= '1';   
        
for k in 0 to CHECK_CASES-1 loop
	wait until rising_edge(clk_Simeck);
   	 I <= I_check(k);
	 Q <= Q_check(k);
end loop;

end process;

  
clock: process				--T = 16 us => clock frequency is 0.0625 MHz (different values for simulation purposes)
begin					
	clk <= '0';
	wait for CLOCK_PERIOD/2;	--32 ns
	clk <= '1';
	wait for CLOCK_PERIOD/2;
end process;

clock_simeck: process			--clock frequency is 2 MHz => T = 0.5 us (different values for simulation purposes)
begin					--32 cycles of operation => t = 16 us
	--for j in 0 to 63 loop 
	clk_Simeck <= '1';	
	wait for CLOCK_PERIOD/64;	--1 ns		  
	clk_Simeck <= '0';
	wait for CLOCK_PERIOD/64;
	--end loop;
end process;

reset: process
begin
	rst <= '0';
	wait for 1 ns;
	rst <= '1';
	wait for 6.5 ns;
	rst <= '0';
	wait;
end process;

end test;  



