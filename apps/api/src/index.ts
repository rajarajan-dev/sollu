import express from 'express';
import cors from 'cors';
import { router as healthRouter } from './routes/health';

const app = express();
app.use(cors());
app.use(express.json());

const port = process.env.PORT ? Number(process.env.PORT) : 3000;

// Root route so visiting http://localhost:3000/ shows a friendly message
app.get('/', (_req, res) => {
  res.send(`API listening on ${port}`);
});

app.use('/health', healthRouter);

app.listen(port, () => {
  // eslint-disable-next-line no-console
  console.log(`API listening on ${port}`);
});
