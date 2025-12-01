import express from "express";
import cookieParser from "cookie-parser";
import logger from "morgan";
// import cors from 'cors';

import indexRouter from "./routes/index.js";
import usersRouter from "./routes/userRouter.js";
import storyRouter from "./routes/storyRouter.js";
import problemRouter from "./routes/problemRouter.js";
import progressRouter from "./routes/progressRouter.js";
import heroineRouter from "./routes/heroineRouter.js";
import choiceRouter from "./routes/choiceRouter.js";
import { notFound } from "./middleware/notFound.js";
import { errorHandler } from "./middleware/errorHandler.js";

const app = express();

// app.use(
//     cors({
//         origin: 'http://localhost:3000', // React 서버 주소
//         credentials: true,
//     })
// );

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

app.use("/", indexRouter);
app.use("/users", usersRouter);
app.use("/stories", storyRouter);
app.use("/progress", progressRouter);
app.use("/heroines", heroineRouter);
app.use("/problems", problemRouter);
app.use("/choices", choiceRouter);

app.use(notFound);

app.use(errorHandler);

export default app;
