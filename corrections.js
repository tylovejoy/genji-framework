//String.prototype.replaceAll = function (search, replace) { return this.split(search).join(replace); };
//String.prototype.replaceAll = function (search, replace) { return this.replace(new RegExp(search.replace(/[-\/\\^$*+?.()|[\]{}]/g, "\\$&"), "g"), replace); };
content = content.replace(/ＴＬＥｒｒ/g, "");
content = content.replace(/rule \("Initialize player variables"\) {\n    event {\n        Ongoing - Each Player;\n        All;\n        All;\n    }\n    actions {\n        Set Player Variable\(Event Player, __languageIndex__, 1\.1\);\n    }\n}\n\n?/g, "");