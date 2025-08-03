# Frontend Service

This is a React single-page application for the notes service.

## Development

To run the application in development mode:

```bash
npm install
npm run dev
```

The application will be available at `http://localhost:5173`.

## Testing

To run the unit tests:

```bash
npm test
```

## Building

To build the application for production:

```bash
npm run build
```

The production-ready files will be located in the `dist` directory.

## Docker

To build and run the Docker container:

```bash
docker build -t frontend-app .
docker run -p 8080:80 frontend-app
```

The application will be available at `http://localhost:8080`.
