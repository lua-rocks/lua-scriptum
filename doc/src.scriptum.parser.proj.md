# ProjectParser



## API

**stripOutRoot** (fullPath\*, rootPath\*) : relativePath  

> Convert full path to relative  
>
> &rarr; **fullPath** (string)  
> &rarr; **rootPath** (string)  
>
> &larr; **relativePath** (string)  

**fs2reqPath** (path\*, rootPath\*) : path  

> Convert filesystem path to require path  
>
> &rarr; **path** (string) `full path to .lua file`  
> &rarr; **rootPath** (string) `full path to the project root`  
>
> &larr; **path** (string)  

**scanDir** (folder\*, fileTree) : fileTree  

> Recursively scan directory and return list with each file path.  
>
> &rarr; **folder** (string) `folder path`  
> &rarr; **fileTree** (table) *[{}]* `table to extend`  
>
> &larr; **fileTree** (table) `result table`  

**filterFiles** (fileTree\*, ext\*) : fileTree  

> Select and return only those files whose extensions match.  
>
> &rarr; **fileTree** (table)  
> &rarr; **ext** (string)  
>
> &larr; **fileTree** (table)  

**projParser.getFiles** (root\*) : files, reqs  

> Get list of all parseable files in directory.  
>
> &rarr; **root** (string) `root directory full path`  
>
> &larr; **files** (table) `list of fs-file paths`  
> &larr; **reqs** (table) `list of require-file paths`  

## Project

+ [Back to root](README.md)