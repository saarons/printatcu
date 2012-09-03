DIRECT_EXTENSIONS = %w(.pdf .eps .ps)
GOOGLE_EXTENSIONS = %w(.odt .ods .doc .docx .xls .xlsx .ppt .pptx .pages .ai .psd .tiff .dxf .svg)

ALL_EXTENSIONS = DIRECT_EXTENSIONS + GOOGLE_EXTENSIONS

SPLIT_LOCATIONS = {
  "Residence Halls" => {
    "Carman"      => /^carman/,
    "Broadway"    => /^broadway/,
    "Claremont"   => /^claremo?nt/,
    "East Campus" => /^ec/,
    "Furnald"     => /^furnald/,
    "Harmony"     => /^harmony/,
    "Hartley"     => /^hartley/,
    "McBain"      => /^mcbain/,
    "Nussbaum"    => /^six00w/,
    "River"       => /^river/,
    "Ruggles"     => /^ruggles/,
    "Schapiro"    => /^schapiro/,
    "Watt"        => /^watt/,
    "Wien"        => /^wien/,
    "Woodbridge"  => /^woodbridge/
  }
}