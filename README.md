# Header2md
> Convert header files to markdown.

This tool was designed primarily with libraries in mind.

The basic idea is that comments become plain text
while source code is packed inside fenced code blocks.

The text you place inside comments is generally not tampered with except:
+ leading whitespace is removed
+ typical C comment margins of the form " * " are removed;
however, this does mean that for dot lists you have to use 2 stars

More than 2 empty lines in the source code will collapse into 2 empty lines.

Your header may end or start with code or comments,
it won't result in any problems.

The special directive `@OMIT` can be used inside comments to hide everything
up until the next comment.
This could be useful to prevent for example copyright notices or header guards,
from leaking into the documentation.
