#!perl -n
#
# Generates packed key data for common algorithms according to rfc7427
# usage: curl https://tools.ietf.org/html/rfc7427 | perl gen_algo.pl
#
# -samy kamkar 06/06/2017

s/<.*?>//g;
s/^\s*//;
s/\s*$//;
s/\s+/ /g;

if (/^A\.[0-3]\.\d+\.\S* (\S+)$/)
{
  ($name = $1) =~ s/-/_/g;
  print "private let SEQUENCE_OBJECT_$name:[UInt8] = [\n";
  $length = 0;
}
elsif (/^length\s*=\s*(\d+)$/i)
{
  $length = $1;
}
elsif ($name && $length && /^[\da-f]{4}\s*:([\s\da-f]+)$/i)
{
  ($tmp = $1) =~ s/\s//g;
  print join(", ", map { "0x$_" } $tmp =~ /(..)/g) . "]\n";
  $name = 0;
}

__DATA__
private let SEQUENCE_OBJECT_sha256WithRSAEncryption:[UInt8] = [
0x30, 0x0D, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86,
0xF7, 0x0D, 0x01, 0x01, 0x0B, 0x05, 0x00]

