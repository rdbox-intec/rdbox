import { TestBed } from '@angular/core/testing';

import { VerificationService } from './verification.service';

describe('VerificationService', () => {
  let service: VerificationService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(VerificationService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
