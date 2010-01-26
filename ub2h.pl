use strict;

use utf8;

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


my $current_book = undef;
my $current_chapter = undef;

sub print_header {
    my ($book, $chapter) = @_;

return <<"HEADER";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
 <html xmlns="http://www.w3.org/1999/xhtml">
 <head>
     <meta http-equiv="content-type" content="text/html; charset=utf-8" />
     <title>$books{$book} $chapter</title>
     <link rel="stylesheet" href="bible.css" />
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


open (BIBLE, "<:encoding(utf8)", $ARGV[0]);

while (<BIBLE>) {
    next if /^#/;
    chomp;
    my @verse = split(/\t/, $_);

    # filter out apocrypha.
    next unless exists $books{$verse[0]};

    if (!defined $current_book || $verse[0] != $current_book) {
        $current_book = $verse[0];
    }

    if (!defined $current_chapter || $verse[1] != $current_chapter) {
        if (defined $current_chapter) {
            print FILE print_footer();
            close FILE;
        }
        open (FILE, ">:encoding(utf8)", join("_", $verse[0], $verse[1]) . ".html");
        print FILE print_header($verse[0], $verse[1]);
        $current_chapter = @verse[1];        
    }
printf ("Writing %s %s:%s\n", 
        $books{$verse[0]}, $current_chapter, $verse[2]);
    print FILE <<"VERSE";    
<p><sup>$verse[2]</sup>$verse[5]</p>
VERSE
}
close FILE;
close BIBLE;
