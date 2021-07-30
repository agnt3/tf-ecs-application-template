const app = require('express')()

app.get('/api', function(req, res) {
    res.set('content-type', 'application/json')
    res.send('{\'status\': \'UP\', \'version\': \'4.0\'}')
})

app.get('/health', function(req, res) {
    res.set('content-type', 'application/json')
    res.send('{\'status\': \'UP\'}')
})

app.listen(3000, function() {
    console.log('Server listening on 3000...')
})