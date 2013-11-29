var fs = require('fs');
var _ = require('underscore');

var header = '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n<plist version="1.0">\n<array>\n'
var footer = '\n</array>\n</plist>';

var open = '\t<dict>'
var close = '</dict>'

var out = '';

fs.readdir('images', function(err, files){
	//console.log(files);
	out = out + header;
	_.each(files, function(f) {
		var filename = f.split('.')[0];

		out = out + open;
		out = out + '\n\t\t<key>name</key>\n';
		out = out + '\t\t<string>' + filename + '</string>\n';
		out = out + '\t\t<key>filename</key>\n';
		out = out + '\t\t<string>' + filename + '</string>\n';
		out = out + '\t' + close + '\n';
	});

	out = out + footer;

	fs.writeFile('images.plist', out, function(err){
		console.log(out);
	});
});


