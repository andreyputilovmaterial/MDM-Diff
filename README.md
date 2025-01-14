# [DEPRECATED]
please use MDM-Diff-Py instead

# MDM-Diff

This is a tool used to compare MDDs. It can be used on P-data files or R-data files. It compares metadata - question/item/category names, labels, and also properties and translations (can be configured, switched on of off).

The result is in html file (and couple more .json files that can be ignored).

It won't show ALL differences (for example, min/max range values for validation, category attributes - ran/fix/other, etc.). UPD: now, as I added comparison of metadata and routing, it can show all differences your are interested in as a survey engineer.

Requires python 3 (python scripts can be compiled into windows executable, but it is important for me to have access to code, as it was originally developed in scripting language and it is executed by interpreting a script - I don't see a problem to install python).

Originally published 12/15/2022 AP

### Usage ###
it was designed to be started from BAT file.

Edit mdmdiff.bat and specify MDD names at the top.

MDD files should be in the same directory as the script.

It can be configured with command-line parameters. For example (in mdmdiff.bat), find
<br /><code>mrscriptcl mdmrep.mrs "/a:INPUT_MDD=%MDD_A%" "/a:RUN_FEATURES=label,properties,translations"</code> (and same for MDD_B)

You can replace <code> "/a:RUN_FEATURES=label,properties,translations"</code> and pass
1. <code> "/a:RUN_FEATURES=label,properties,translations,scripting"</code> (default is <code>label,properties,translations</code>) - remove certain parts separated with comma to not have some of the columns populated. For example, you don't need a column for translations, change to <code>RUN_FEATURES=label,properties</code>. Or, you don't need properties, change to <code>RUN_FEATURES=label</code>. The order is reflected, you can change <code>label,properties,scripting</code> to <code>label,scripting,properties</code>.

2. You can add <code> /d:RUN_SECTIONS=55</code> (that's default), where "55" is a combination of bitwise flags. Use this to include or exclude certain sections from the report. "1" for languages (I recomment having it on as it does not occupy much space in the report but it is important to see which translation overlays are included), "2" for shared lists, "4"  for all normal items (questions) in MDD, "8" to have a section with variables listed (it is quite useless but can be displayed if you want to), "16" for pages - quite useless too but it does not take much space, "32" for global MDM properties (i.e. "JobNumber"), "64" to have a routing section included. To find a combination you can just normally add these numbers (each number once). So, if you need to include routing, set <code> /d:RUN_SECTIONS=119</code>. You'll also have to have "label" included in "Features" as Routing is printed in the column for labels. So, if labels are not included, routing will be missing, even if you have this section added.

3. You can add <code> "/a:RUN_FEATURES_LABEL_FORCE_CONTEXT=Question"</code> (that's default), You can set default context to read labels. Usually it's "Question" or "Analysis", depending if you need to see what you have in metadata in survey programming or data processing.

3. You can add <code> "/a:RUN_FEATURES_PROPERTIES_CONTEXTS=Analysis,Question"</code> (that's default), a context to read properties from. Multiple contexts can be specified (comma-separated). Analysis and Question are usually good to go, you shouldn't need anything else. If you open your PROCESSED data files and review metadata syntax, and you don't see properties that were defined in the survey - that's because they were stored in Question context and now you are looking at Analysis context. Having both Analysis and Question helps you have displayed both.

### Runtimes ###
Several minutes at most (if yuo include all translations, routing, and everything, it could take more than 15 minutes per MDD; yeah, this first step is slow; just replacements for escaping characters and direct writing to json take enormous time; I should probably look for alternative (and native) ways to write data).

The biggest part is iterating over fields with mrs script and writing to a json file. Maybe this can be done with API in C# or in other programming language, but I am using our natural scripting that relies on outdated and stupid VBScript, so I can't do much not going for major changes in design.

### Examples of outputs ###

### Other possible features and possible development ###
1. Jira links - just click "(show)" in Jira section at the top, confirm project number, url, and query filter, and press "Run". Jira links will be added as the right most column - you can check tickets passign these links.
2. Translations - it is configured to be on by default just to show the power of this tool, that it can display diffs in translations. But I think you don't need it in most projects. You can easily turn it off by changing <code></code>
3. Routing diffs - <b>It is now ready!</b> <br />Initially I did not want to include it as it looked too stupid for me - comparing text is so simple task that you don't need special tools for me to check for changes. Also, it increases report size.
