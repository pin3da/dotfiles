var fs = require('fs'),
    xml2js = require('xml2js');

var parser = new xml2js.Parser();
fs.readFile(process.argv[2], function (err, data) {
  if (err) {
    console.error("The file can't be read");
  } else {
    parser.parseString(data, function (err1, result) {
      if (err1) {
        console.error("The file can't be parsed");
      } else {
        var entries = result.rhythmdb.entry;
        var non_rep = [];
        for (var i = 0; i < entries.length; ++i) {
          var song = entries[i];
          //if ('song' != song['$'].type) continue;
          var title  = (song.title) ? song.title[0].toLowerCase() : '';
          var artist = (song.artist) ? song.artist[0].toLowerCase() : '';
          var duration = (song.duration) ? song.duration[0].toLowerCase() : '0';

          var seen = false;
          for (var j = 0; j < non_rep.length; ++j) {
            var other = non_rep[j];
            var o_title  = (other.title) ? other.title[0].toLowerCase() : '';
            var o_artist = (other.artist) ? other.artist[0].toLowerCase() : '';
            var o_duration = (other.duration) ? other.duration[0].toLowerCase() :'0' ;
            if (o_title == title && o_artist == artist && Math.abs(+o_duration - +duration) < 3) {
              seen = true;
              break;
            }
          }

          if (!seen) {
            non_rep.push(song);
          }
        }
        result.rhythmdb.entry = non_rep;
        console.info((entries.length - non_rep.length) + ' songs deleted');
        var builder = new xml2js.Builder();
        fs.writeFile('/tmp/non_rep.xml', builder.buildObject(result), function (err){
          if (err) {
            console.err("Failed to write");
          } else {
            console.info('File create in /tmp/non_rep.xml copy it to your rhythmbox location');
          }
        });
      }
    });
  }
});
