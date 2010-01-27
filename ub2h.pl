use strict;

use utf8;
$| = 0;

my $translation_name;
my $identifier;

my %books = (
    '01O'	=> 'Genesis',
    '02O'	=> 'Exodus',
    '03O'	=> 'Leviticus',
    '04O'	=> 'Numbers',
    '05O'	=> 'Deuteronomy',
    '06O'	=> 'Joshua',
    '07O'	=> 'Judges',
    '08O'	=> 'Ruth',
    '09O'	=> '1 Samuel',
    '10O'	=> '2 Samuel',
    '11O'	=> '1 Kings',
    '12O'	=> '2 Kings',
    '13O'	=> '1 Chronicles',
    '14O'	=> '2 Chronicles',
    '15O'	=> 'Ezra',
    '16O'	=> 'Nehemiah',
    '17O'	=> 'Esther',
    '18O'	=> 'Job',
    '19O'	=> 'Psalms',
    '20O'	=> 'Proverbs',
    '21O'	=> 'Ecclesiastes',
    '22O'	=> 'Song of Solomon',
    '23O'	=> 'Isaiah',
    '24O'	=> 'Jeremiah',
    '25O'	=> 'Lamentations',
    '26O'	=> 'Ezekiel',
    '27O'	=> 'Daniel',
    '28O'	=> 'Hosea',
    '29O'	=> 'Joel',
    '30O'	=> 'Amos',
    '31O'	=> 'Obadiah',
    '32O'	=> 'Jonah',
    '33O'	=> 'Micah',
    '34O'	=> 'Nahum',
    '35O'	=> 'Habakkuk',
    '36O'	=> 'Zephaniah',
    '37O'	=> 'Haggai',
    '38O'	=> 'Zechariah',
    '39O'	=> 'Malachi',
    '40N'	=> 'Matthew',
    '41N'	=> 'Mark',
    '42N'	=> 'Luke',
    '43N'	=> 'John',
    '44N'	=> 'Acts of the Apostles',
    '45N'	=> 'Romans',
    '46N'	=> '1 Corinthians',
    '47N'	=> '2 Corinthians',
    '48N'	=> 'Galatians',
    '49N'	=> 'Ephesians',
    '50N'	=> 'Philippians',
    '51N'	=> 'Colossians',
    '52N'	=> '1 Thessalonians',
    '53N'	=> '2 Thessalonians',
    '54N'	=> '1 Timothy',
    '55N'	=> '2 Timothy',
    '56N'	=> 'Titus',
    '57N'	=> 'Philemon',
    '58N'	=> 'Hebrews',
    '59N'	=> 'James',
    '60N'	=> '1 Peter',
    '61N'	=> '2 Peter',
    '62N'	=> '1 John',
    '63N'	=> '2 John',
    '64N'	=> '3 John',
    '65N'	=> 'Jude',
    '66N'	=> 'Revelation',
);

my %books_written;

my %poetry_books = (
    '19O'  => 1,
    '23O'  => 1,
    '66N'  => 1,
    '20N'  => 1,
   );

my $current_book = undef;
my $current_chapter = undef;

sub print_header {
    my ($book, $chapter) = @_;
    
    my $css = exists $poetry_books{$book} ? "poetry.css" : "bible.css";

return <<"HEADER";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
 <html xmlns="http://www.w3.org/1999/xhtml">
 <head>
     <meta http-equiv="content-type" content="text/html; charset=utf-8" />
     <link rel="stylesheet" href="$css" />
</head>
<body>
<h1> $books{$book} Chapter $chapter </h1>
HEADER
}
sub print_footer {
    return <<"FOOTER";
</body>
</html>
FOOTER
}



sub epub_toc_ncx {
    my ($title, $identifier) = @_;
    my $head = <<"TOCHEAD";

   <head>
      <meta name="dtb:uid" content=
         "http://www.unboundbible.org/epub/$identifier" />
      <meta name="dtb:depth" content="2"/>
      <meta name="dtb:totalPageCount" content="0"/>
      <meta name="dtb:maxPageNumber" content="0"/>
   </head>

   <docTitle>
      <text>$title</text>
   </docTitle>
TOCHEAD

    my $id = 1;
    my $navmap;
    foreach my $book_code (sort keys %books_written) {
        my $book_name = $books{$book_code};
        my $n_books   = $books_written{$book_code};
        my $book_intro = join("_", $book_code, "1") . ".html";
        $navmap .= <<"NAVPOINTHEADER";
<navPoint id="toc$id" playOrder="$id">
   <navLabel><text>$book_name</text></navLabel>
   <content src="$book_intro" />
NAVPOINTHEADER
        $id++;
        foreach my $chapter (1 .. $n_books) {
            my $book_id = join("_", $book_code, $chapter);
            $navmap .= <<"NAVPOINTCHAPTER";
  <navPoint id="toc$id" playOrder="$id">
     <navLabel><text>$book_name $chapter</text></navLabel>
     <content src="$book_id.html" />
  </navPoint>
NAVPOINTCHAPTER
            $id++;
        }
        
        $navmap .= <<"NAVPOINTFOOTER";
</navPoint>
NAVPOINTFOOTER

    }
    my $xmldoc = <<"XMLDOC";
<?xml version="1.0"?>
<!DOCTYPE ncx PUBLIC "-//NISO//DTD ncx 2005-1//EN" 
   "http://www.daisy.org/z3986/2005/ncx-2005-1.dtd">
<ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1">

$head

<navMap>
$navmap
</navMap>

</ncx>


XMLDOC

}

sub epub_container_xml {
    return <<"CONTAINERXML";
<?xml version="1.0"?>
<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
   <rootfiles>
      <rootfile full-path="content.opf" media-type="application/oebps-package+xml"/>
   </rootfiles>
</container>
CONTAINERXML
}


sub content_opf_xml {
    my ($title, $language, $identifier) = @_;
    my $metadata = <<"METADATA";
<metadata xmlns:dc="http://purl.org/dc/elements/1.1/"
      xmlns:dcterms="http://purl.org/dc/terms/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:opf="http://www.idpf.org/2007/opf">
      <dc:title>$title</dc:title>
      <dc:language xsi:type="dcterms:RFC3066">$language</dc:language>
      <dc:identifier id="dcidid" opf:scheme="URI">
          http://www.unboundbible.org/epub/$identifier
      </dc:identifier>
</metadata>
METADATA

    my @manifest_entries = (
           "<item id=\"ncx\" href=\"toc.ncx\" media-type=\"application/x-dtbncx+xml\" />",
           "<item id=\"css1\" href=\"bible.css\" media-type=\"text/css\" />",
           "<item id=\"css2\" href=\"poetry.css\" media-type=\"text/css\" />",
          );

    my @spine_entries;
    foreach my $book (sort keys %books_written) {
        my $n_books = $books_written{$book};
        for my $chapter (1 .. $n_books) {
            my $id = join("_", $book, $chapter);
            my $manifest_entry = <<"MANIFEST";
<item id="$id" href="$id.html" media-type="application/xhtml+xml" />
MANIFEST
            push @manifest_entries, $manifest_entry;
            push @spine_entries, "<itemref idref=\"$id\" />";
        }
    }

    my $manifest = "<manifest>" . join("\n\t", @manifest_entries) . "\n</manifest>";
    my $spine = "<spine>" . join("\n\t", @spine_entries) . "\n</spine>";

    my $xmldoc = <<"XMLDOC";
<?xml version="1.0"?>
<package xmlns="http://www.idpf.org/2007/opf" unique-identifier="dcidid" 
   version="2.0">

$metadata

$manifest

$spine
</package>


XMLDOC

  return $xmldoc;
}



my $i = 1;
open (BIBLE, "<:encoding(utf8)", $ARGV[0]);

while (<BIBLE>) {
    chomp;
    s/\r//g;
    if (/^#name/) {
        my ($header, $content) = split("\t", $_);
        $translation_name = "Holy Bible - " . $content;
        $content =~ s/[^A-Z]//g;
        $identifier = $content;
        next;
    }
    next if /^#/;
    chomp;
    my @verse = split(/\t/, $_);

    next unless exists $books{$verse[0]};

    if (!defined $current_book || $verse[0] != $current_book) {
        $books_written{$current_book} = $current_chapter
          if (defined $current_book);

        $current_book = $verse[0];
        $current_chapter = undef;
        print "\nConverting: $books{$current_book}\n";
        $i = 1;
    }

    if (!defined $current_chapter || $verse[1] != $current_chapter) {
        if (defined $current_chapter) {
            print FILE print_footer();
            close FILE;
        }

        print "opening: " . join("_", $verse[0], $verse[1]) . "\n";
        open (FILE, ">:encoding(utf8)", "output/" . join("_", $verse[0], $verse[1]) . ".html");
        print FILE print_header($verse[0], $verse[1]);
        $current_chapter = @verse[1];    

    }

    #print ".";
    #print "\n" unless ($i++ % 72);

    print FILE <<"VERSE";    
<p><sup>$verse[2]</sup>$verse[5]</p>
VERSE
}
$books_written{$current_book} = $current_chapter
  if (defined $current_book);
close FILE;
close BIBLE;
print "\n";

# write container
open (CONTAINER, "> output/META-INF/container.xml");
print CONTAINER epub_container_xml();
close CONTAINER;

# write content.opf
open (CONTENT, "> output/content.opf");
print CONTENT content_opf_xml($translation_name, $ARGV[1], $identifier);
close CONTENT;

# write TOC
open (CONTENT, "> output/toc.ncx");
print CONTENT epub_toc_ncx($translation_name, $identifier);
close CONTENT;

# write MIMETYPE
open (MIMETYPE, "> output/mimetype");
print MIMETYPE "application/epub+zip";
close MIMETYPE;


