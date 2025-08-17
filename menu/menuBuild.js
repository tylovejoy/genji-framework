
var menu;//Input

let result = "";
let result_macro = "";
let result_pointers = "";
let result_textConst = "";
let result_action = [];
let result_textMutable = [];
let indexPtrCounter = 0;
const MaxSubmenus = 50;

build(menu);
result += result_macro;
if (indexPtrCounter < 500)
    result += `rule "Menu | Define Pointers & String Consts":\n${result_pointers}\n${result_textConst}\n`
else
    result += `rule "Menu | Define Pointers":\n${result_pointers}\nrule "Menu | Define String Consts":\n${result_textConst}\n`
if (result_textMutable)
    result += `def __MenuText__():\n\t@Name "Menu | SUB Update Text"\n\tswitch (hostPlayer.__MenuCurrent__):\n${result_textMutable.join("\t\t\tbreak\n")}\n`
if (result_action)
    result += `def __MenuAction__():\n\t@Name "Menu | SUB Actions"\n\tswitch (hostPlayer.__MenuCurrent__ * ${MaxSubmenus} + hostPlayer.__MenuSelection__):\n${result_action.join("\t\t\tbreak\n")}`;
//console.log(result);
result;//Output

function build(node, parentIndexPtr = 1, currPage = 0) {
    if (node === 0) return 0;

    if ("text" in node) {
        ++indexPtrCounter;
        result_macro += `macro menuMacroText${indexPtrCounter}():\n\t__MenuString__[${indexPtrCounter}] = ${node.text}\n\n`
        if ("update" in node)
            result_textMutable.push(`\t\tcase ${indexPtrCounter}:\n\t\t\tmenuMacroText${indexPtrCounter}()\n\n`);
        else
            result_textConst += `\tmenuMacroText${indexPtrCounter}()\n`;
    }
    if ("code" in node) {
        result_macro += `macro menuMacroCode${parentIndexPtr * MaxSubmenus + currPage + 1}():\n\t${node.code}\n\n`
        result_action.push(`\t\tcase ${parentIndexPtr * MaxSubmenus + currPage + 1}:\n\t\t\tmenuMacroCode${parentIndexPtr * MaxSubmenus + currPage + 1}()\n`);
    }

    if ("pages" in node) {
        let currIndexPtr = indexPtrCounter;
        let subIndices = [];
        node.pages.forEach((child, i) => {
            subIndices.push(build(child, currIndexPtr, i));
        });
        subIndices.unshift(parentIndexPtr);
        result_pointers += `\t__MenuPointer__[${currIndexPtr}] = [${subIndices.toString()}]\n`;
        return currIndexPtr;
    }
    return 0;
}