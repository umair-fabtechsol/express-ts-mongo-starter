import { IUserDoc } from './modules/user/user.interfaces.ts';

declare module 'express-serve-static-core' {
  export interface Request {
    user: IUserDoc;
  }
}
