import { TestBed } from '@angular/core/testing';

import { VerificationGuard } from './verification.guard';

describe('VerificationGuard', () => {
  let guard: VerificationGuard;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    guard = TestBed.inject(VerificationGuard);
  });

  it('should be created', () => {
    expect(guard).toBeTruthy();
  });
});
