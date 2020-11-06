const path = require('path');

module.exports = {
    mode: 'production',
    context: __dirname,
    entry: './src/app.ts',
    module: {
        rules: [{
            test: /\.ts?$/,
            use: 'ts-loader',
            exclude: [
                /node_modules/,
            ],
        }],
    },
    output: {
        filename: 'client.prod.js',
        path: path.resolve(__dirname, 'lib'),
    },
    resolve: {
        extensions: ['.ts'],
    },
};
