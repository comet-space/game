const path = require('path');

module.exports = {
    mode: 'development',
    context: __dirname,
    devtool: 'inline-source-map',
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
        filename: 'client.dev.js',
        path: path.resolve(__dirname, 'lib'),
    },
    resolve: {
        extensions: ['.ts'],
    },
};
