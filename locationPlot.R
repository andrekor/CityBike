#Currently for testing purposes

# grab a center/zoom map and compute its bounding box
gc <- geocode("white house, washington dc")
gOslo <- geocode("Oslo, majorstua")

map <- get_map(gOslo, zoom = 13)

(bb <- attr(map, "bb"))
(bbox <- bb2bbox(bb))
# use the bounding box to get a stamen map
stamMap <- get_stamenmap(bbox)
ggmap(map) +
  geom_point(
    aes(x = lon, y = lat),
    data = gc, colour = "red", size = 3 
  )


ggmap(map) +
  geom_point(
    aes(x = 10.714784, y = 59.930603),
    data = gc, colour = "red", size = 2
)
## End(Not run)