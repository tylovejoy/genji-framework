var menu;//Input

if (!menu) throw new SyntaxError("Menu JSON must be non-empty")
validate(menu);
"\n";//Output

function validate(node) {
    if (node === 0) return;

    if (node === null || typeof node !== "object" || Array.isArray(node))
        throw new SyntaxError("Menu must be an Object or 0");

    for (let key of Object.keys(node))
        if (["text", "code", "update", "pages"].indexOf(key) === -1)
            throw new SyntaxError(`Unknown key '${key}'`);

    if ("text" in node && typeof node.text !== "string")
        throw new SyntaxError("Key 'text' must be a String");

    if ("update" in node) {
        if (!("text" in node))
            throw new SyntaxError("Key 'text' is required for 'update'");
        if (typeof node.update !== "boolean")
            throw new SyntaxError("Key 'update' must be a Boolean");
    }

    if ("code" in node && typeof node.code !== "string")
        throw new SyntaxError("Key 'code' must be a String");

    if ("pages" in node) {
        if (!Array.isArray(node.pages))
            throw new SyntaxError("Key 'pages' must be an Array");
        node.pages.forEach(child => validate(child));
    }
}