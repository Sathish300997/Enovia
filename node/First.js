var fs=require("fs")
fs.readFile('demo.txt',function(err,data)
{
    if(err)
    {
        return console.log.error(err);
    }
    console.log("async data" + data.toString());
});