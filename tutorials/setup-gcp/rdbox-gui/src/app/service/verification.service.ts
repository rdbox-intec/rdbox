import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class VerificationService {
  private verification: boolean = false;

  constructor() { }

  registVerification(state: boolean): void {
    this.verification = state;
  }

  isVerificationed(): boolean {
    return this.verification
  }
}
