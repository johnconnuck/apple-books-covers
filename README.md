# Apple Books covers

This is a Calibre plugin to download high-resolution cover images
from the Apple Books store using the [iTunes API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html).
It will search the one or two configured store countries first
by trying to look up the book ISBN if configured,
and if that is unsuccessful it will perform a search using the author(s) and book title.

Note that the API has a rate limit of about 20 requests per minute,
so several metadata requests in quick succession may cause failures.
