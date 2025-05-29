local function rgb(r, g, b)
    g = g or r
    b = b or g

    return {
        r = r / 255,
        g = g / 255,
        b = b / 255,
    }
end

return {
    bkg = rgb(0),
    text = rgb(255),
    line = rgb(210),
    snake = rgb(0, 204, 0),
    food = rgb(255, 102, 0),
    death = rgb(255, 0)
}